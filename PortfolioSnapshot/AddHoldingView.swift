//
//  AddHoldingView.swift
//  PortfolioSnapshot
//
//  Created by Tom Stevenson on 1/2/26.
//

import SwiftUI
import SwiftData

struct AddHoldingView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var symbol = ""
    @State private var quantityString = ""
    @State private var purchasePriceString = ""
    @State private var includePurchaseDate = false
    @State private var purchaseDate = Date()
    
    @State private var showingError = false
    @State private var errorMessage = ""
    
    private var isValid: Bool {
        !symbol.trimmingCharacters(in: .whitespaces).isEmpty &&
        Double(quantityString) != nil &&
        Double(quantityString)! > 0 &&
        Double(purchasePriceString) != nil &&
        Double(purchasePriceString)! > 0
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Stock Details") {
                    TextField("Symbol (e.g., AAPL)", text: $symbol)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                    
                    TextField("Quantity", text: $quantityString)
                        .keyboardType(.decimalPad)
                    
                    TextField("Purchase Price ($)", text: $purchasePriceString)
                        .keyboardType(.decimalPad)
                }
                
                Section {
                    Toggle("Include Purchase Date", isOn: $includePurchaseDate)
                    
                    if includePurchaseDate {
                        DatePicker(
                            "Purchase Date",
                            selection: $purchaseDate,
                            in: ...Date(),
                            displayedComponents: .date
                        )
                    }
                } footer: {
                    Text("Purchase date is optional and for your reference only.")
                }
            }
            .navigationTitle("Add Holding")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addHolding()
                    }
                    .disabled(!isValid)
                    .fontWeight(.semibold)
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func addHolding() {
        guard let quantity = Double(quantityString),
              let purchasePrice = Double(purchasePriceString) else {
            errorMessage = "Please enter valid numbers for quantity and price."
            showingError = true
            return
        }
        
        let cleanSymbol = symbol.uppercased().trimmingCharacters(in: .whitespaces)
        
        guard !cleanSymbol.isEmpty else {
            errorMessage = "Please enter a stock symbol."
            showingError = true
            return
        }
        
        let holding = Holding(
            symbol: cleanSymbol,
            quantity: quantity,
            purchasePrice: purchasePrice,
            purchaseDate: includePurchaseDate ? purchaseDate : nil
        )
        
        modelContext.insert(holding)
        dismiss()
    }
}

// MARK: - Edit Holding View

struct EditHoldingView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var holding: Holding
    
    @State private var symbol: String = ""
    @State private var quantityString: String = ""
    @State private var purchasePriceString: String = ""
    @State private var includePurchaseDate: Bool = false
    @State private var purchaseDate: Date = Date()
    
    @State private var showingDeleteAlert = false
    
    private var isValid: Bool {
        !symbol.trimmingCharacters(in: .whitespaces).isEmpty &&
        Double(quantityString) != nil &&
        Double(quantityString)! > 0 &&
        Double(purchasePriceString) != nil &&
        Double(purchasePriceString)! > 0
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Stock Details") {
                    TextField("Symbol (e.g., AAPL)", text: $symbol)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                    
                    TextField("Quantity", text: $quantityString)
                        .keyboardType(.decimalPad)
                    
                    TextField("Purchase Price ($)", text: $purchasePriceString)
                        .keyboardType(.decimalPad)
                }
                
                Section {
                    Toggle("Include Purchase Date", isOn: $includePurchaseDate)
                    
                    if includePurchaseDate {
                        DatePicker(
                            "Purchase Date",
                            selection: $purchaseDate,
                            in: ...Date(),
                            displayedComponents: .date
                        )
                    }
                }
                
                if let price = holding.currentPrice {
                    Section("Market Data") {
                        LabeledContent("Current Price") {
                            Text(price, format: .currency(code: "USD"))
                        }
                        
                        if let lastUpdated = holding.lastUpdated {
                            LabeledContent("Last Updated") {
                                Text(lastUpdated, style: .relative)
                            }
                        }
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Delete Holding")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Edit Holding")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                    .disabled(!isValid)
                    .fontWeight(.semibold)
                }
            }
            .alert("Delete Holding?", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteHolding()
                }
            } message: {
                Text("This will permanently remove \(holding.displaySymbol) from your portfolio.")
            }
            .onAppear {
                loadHoldingData()
            }
        }
    }
    
    private func loadHoldingData() {
        symbol = holding.symbol
        quantityString = String(format: "%.4f", holding.quantity)
        purchasePriceString = String(format: "%.2f", holding.purchasePrice)
        includePurchaseDate = holding.purchaseDate != nil
        purchaseDate = holding.purchaseDate ?? Date()
    }
    
    private func saveChanges() {
        guard let quantity = Double(quantityString),
              let purchasePrice = Double(purchasePriceString) else {
            return
        }
        
        holding.symbol = symbol.uppercased().trimmingCharacters(in: .whitespaces)
        holding.quantity = (quantity * 10000).rounded() / 10000
        holding.purchasePrice = purchasePrice
        holding.purchaseDate = includePurchaseDate ? purchaseDate : nil
        
        // Clear cached price if symbol changed
        if holding.symbol != symbol.uppercased() {
            holding.currentPrice = nil
            holding.lastUpdated = nil
        }
        
        dismiss()
    }
    
    private func deleteHolding() {
        modelContext.delete(holding)
        dismiss()
    }
}

// MARK: - Previews

#Preview("Add Holding") {
    AddHoldingView()
        .modelContainer(for: Holding.self, inMemory: true)
}

