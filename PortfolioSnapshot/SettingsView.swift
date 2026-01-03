//
//  SettingsView.swift
//  PortfolioSnapshot
//
//  Created by Tom Stevenson on 1/2/26.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        AboutView()
                    } label: {
                        Label("About", systemImage: "info.circle")
                    }
                }
                
                Section {
                    Link(destination: URL(string: "https://twelvedata.com")!) {
                        Label("Twelve Data Website", systemImage: "chart.line.uptrend.xyaxis")
                    }
                } header: {
                    Text("Data Provider")
                } footer: {
                    Text("Market data is provided by Twelve Data's free API tier.")
                }
                
                Section("Legal") {
                    Link(destination: URL(string: "https://stevenson.mobi/apps/PortfolioSnapshot/privacy")!) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }
                    
                    Link(destination: URL(string: "https://stevenson.mobi/apps/PortfolioSnapshot/terms")!) {
                        Label("Terms of Use", systemImage: "doc.text")
                    }
                }
                
                Section("Support") {
                    Link(destination: URL(string: "mailto:developer@stevenson.mobi")!) {
                        Label("Contact Developer", systemImage: "envelope")
                    }
                }
                
                Section("App Info") {
                    LabeledContent("Version") {
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                    }
                    
                    LabeledContent("Build") {
                        Text(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - About View

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // App Icon/Logo area
                VStack(spacing: 12) {
                    // Use the app icon image if available, otherwise SF Symbol
                    Image(systemName: "chart.pie.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(red: 0.2, green: 0.5, blue: 0.9), Color(red: 0.4, green: 0.7, blue: 0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text("Portfolio Snapshot")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Track your investments at a glance")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 20)
                
                Divider()
                    .padding(.horizontal, 40)
                
                // Data Attribution Section
                VStack(spacing: 16) {
                    Text("Market Data Attribution")
                        .font(.headline)
                    
                    VStack(spacing: 12) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 32))
                            .foregroundStyle(.green)
                        
                        Text("Market data by Twelve Data")
                            .font(.body)
                            .fontWeight(.medium)
                        
                        Link(destination: URL(string: "https://twelvedata.com")!) {
                            HStack {
                                Text("Visit twelvedata.com")
                                Image(systemName: "arrow.up.right")
                                    .font(.caption)
                            }
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                
                // Features Section
                VStack(spacing: 16) {
                    Text("Features")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        FeatureRow(
                            icon: "plus.circle.fill",
                            title: "Add Holdings",
                            description: "Track stocks with symbol, quantity, and purchase price"
                        )
                        
                        FeatureRow(
                            icon: "arrow.clockwise.circle.fill",
                            title: "Live Prices",
                            description: "Pull to refresh current market prices"
                        )
                        
                        FeatureRow(
                            icon: "chart.line.uptrend.xyaxis.circle.fill",
                            title: "Gain/Loss Tracking",
                            description: "See your portfolio performance at a glance"
                        )
                        
                        FeatureRow(
                            icon: "iphone.circle.fill",
                            title: "Local Storage",
                            description: "Your data stays on your device"
                        )
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                
                // Legal Links
                VStack(spacing: 12) {
                    Link(destination: URL(string: "https://stevenson.mobi/apps/PortfolioSnapshot/privacy")!) {
                        Text("Privacy Policy")
                            .font(.footnote)
                            .foregroundStyle(.blue)
                    }
                    
                    Link(destination: URL(string: "https://stevenson.mobi/apps/PortfolioSnapshot/terms")!) {
                        Text("Terms of Use")
                            .font(.footnote)
                            .foregroundStyle(.blue)
                    }
                }
                
                // Disclaimer
                VStack(spacing: 8) {
                    Text("Disclaimer")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    
                    Text("This app is for informational purposes only. Market data may be delayed. Not financial advice. Past performance does not guarantee future results.")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 20)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Feature Row

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 28)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Previews

#Preview("Settings") {
    SettingsView()
}

#Preview("About") {
    NavigationStack {
        AboutView()
    }
}
