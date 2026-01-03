//
//  PortfolioView.swift
//  PortfolioSnapshot
//
//  Created by Tom Stevenson on 1/2/26.
//

import SwiftUI
import SwiftData

struct PortfolioView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Holding.symbol) private var holdings: [Holding]
    @StateObject private var dataService = TwelveDataService()
    
    @State private var showingAddHolding = false
    @State private var showingSettings = false
    @State private var holdingToEdit: Holding?
    
    // MARK: - Computed Properties
    
    private var totalCostBasis: Double {
        holdings.reduce(0) { $0 + $1.costBasis }
    }
    
    private var totalMarketValue: Double? {
        let values = holdings.compactMap { $0.marketValue }
        guard values.count == holdings.count, !holdings.isEmpty else { return nil }
        return values.reduce(0, +)
    }
    
    private var totalGainLoss: Double? {
        guard let marketValue = totalMarketValue else { return nil }
        return marketValue - totalCostBasis
    }
    
    private var totalGainLossPercent: Double? {
        guard let gainLoss = totalGainLoss, totalCostBasis > 0 else { return nil }
        return (gainLoss / totalCostBasis) * 100
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if holdings.isEmpty {
                    emptyStateView
                } else {
                    portfolioContent
                }
                
                // Attribution footer
                attributionFooter
            }
            .navigationTitle("Portfolio")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddHolding = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddHolding) {
                AddHoldingView()
            }
            .sheet(item: $holdingToEdit) { holding in
                EditHoldingView(holding: holding)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .refreshable {
                await dataService.updatePrices(for: holdings)
            }
            .task {
                // Fetch prices when view appears
                if !holdings.isEmpty {
                    await dataService.updatePrices(for: holdings)
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "chart.pie")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)
            
            Text("No Holdings Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Tap + to add your first stock holding")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    private var portfolioContent: some View {
        List {
            // Summary Section
            Section {
                summaryCard
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            
            // Holdings Section
            Section("Holdings") {
                ForEach(holdings) { holding in
                    HoldingRow(holding: holding)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            holdingToEdit = holding
                        }
                }
                .onDelete(perform: deleteHoldings)
            }
        }
        .listStyle(.insetGrouped)
        .overlay {
            if dataService.isLoading {
                ProgressView()
                    .scaleEffect(0.8)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .padding(.top, 20)
            }
        }
    }
    
    private var summaryCard: some View {
        VStack(spacing: 16) {
            // Total Value
            VStack(spacing: 4) {
                Text("Portfolio Value")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                if let value = totalMarketValue {
                    Text(value, format: .currency(code: "USD"))
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                } else {
                    Text(totalCostBasis, format: .currency(code: "USD"))
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }
            
            // Gain/Loss
            if let gainLoss = totalGainLoss, let percent = totalGainLossPercent {
                HStack(spacing: 8) {
                    Image(systemName: gainLoss >= 0 ? "arrow.up.right" : "arrow.down.right")
                        .font(.caption)
                    
                    Text(gainLoss, format: .currency(code: "USD"))
                        .fontWeight(.medium)
                    
                    Text("(\(percent, specifier: "%.2f")%)")
                        .font(.subheadline)
                }
                .foregroundStyle(gainLoss >= 0 ? .green : .red)
            } else if !holdings.isEmpty {
                Text("Pull to refresh prices")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
    }
    
    private var attributionFooter: some View {
        HStack {
            Spacer()
            Text("Data by ")
                .font(.caption2)
                .foregroundStyle(.secondary)
            + Text("Twelve Data")
                .font(.caption2)
                .foregroundStyle(.blue)
            Spacer()
        }
        .padding(.vertical, 8)
        .background(Color(.systemGroupedBackground))
        .onTapGesture {
            if let url = URL(string: "https://twelvedata.com") {
                UIApplication.shared.open(url)
            }
        }
    }
    
    // MARK: - Actions
    
    private func deleteHoldings(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(holdings[index])
            }
        }
    }
}

// MARK: - Holding Row

struct HoldingRow: View {
    let holding: Holding
    
    var body: some View {
        HStack {
            // Symbol and Quantity
            VStack(alignment: .leading, spacing: 4) {
                Text(holding.displaySymbol)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("\(holding.quantity, specifier: "%.4f") shares")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Value and Gain/Loss
            VStack(alignment: .trailing, spacing: 4) {
                if let value = holding.marketValue {
                    Text(value, format: .currency(code: "USD"))
                        .font(.subheadline)
                        .fontWeight(.medium)
                } else {
                    Text(holding.costBasis, format: .currency(code: "USD"))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                if let gainLoss = holding.gainLoss, let percent = holding.gainLossPercent {
                    HStack(spacing: 2) {
                        Text(gainLoss >= 0 ? "+" : "")
                        + Text(gainLoss, format: .currency(code: "USD"))
                        Text("(\(percent, specifier: "%.1f")%)")
                    }
                    .font(.caption)
                    .foregroundStyle(gainLoss >= 0 ? .green : .red)
                } else if holding.currentPrice == nil {
                    Text("—")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview

#Preview {
    PortfolioView()
        .modelContainer(for: Holding.self, inMemory: true)
}

