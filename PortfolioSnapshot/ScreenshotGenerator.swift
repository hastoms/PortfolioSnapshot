//
//  ScreenshotGenerator.swift
//  PortfolioSnapshot
//
//  Use these previews to generate App Store screenshots.
//  Run each preview in Xcode, then take screenshots with ⌘+S in the Canvas.
//
//  Required sizes:
//  - 6.7" display: 1290 x 2796 pixels (iPhone 15 Pro Max)
//  - 5.5" display: 1242 x 2208 pixels (iPhone 8 Plus)
//

import SwiftUI
import SwiftData

// MARK: - Screenshot 1: Empty State / Welcome

struct Screenshot1_Welcome: View {
    var body: some View {
        ScreenshotFrame(
            headline: "Track Your\nPortfolio",
            subheadline: "Simple. Private. Powerful."
        ) {
            // Simulated app screen
            VStack(spacing: 0) {
                // Nav bar
                HStack {
                    Image(systemName: "gearshape")
                        .foregroundStyle(.blue)
                    Spacer()
                    Text("Portfolio")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "plus")
                        .foregroundStyle(.blue)
                }
                .padding()
                .background(Color(.systemBackground))
                
                Spacer()
                
                VStack(spacing: 20) {
                    Image(systemName: "chart.pie")
                        .font(.system(size: 64))
                        .foregroundStyle(.secondary)
                    
                    Text("No Holdings Yet")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Tap + to add your first stock holding")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Footer
                HStack {
                    Text("Data by ")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    + Text("Twelve Data")
                        .font(.caption2)
                        .foregroundStyle(.blue)
                }
                .padding(.vertical, 8)
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

// MARK: - Screenshot 2: Portfolio with Holdings

struct Screenshot2_Portfolio: View {
    var body: some View {
        ScreenshotFrame(
            headline: "See Your\nGains & Losses",
            subheadline: "Real-time price updates"
        ) {
            VStack(spacing: 0) {
                // Nav bar
                HStack {
                    Image(systemName: "gearshape")
                        .foregroundStyle(.blue)
                    Spacer()
                    Text("Portfolio")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "plus")
                        .foregroundStyle(.blue)
                }
                .padding()
                .background(Color(.systemBackground))
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Summary Card
                        VStack(spacing: 16) {
                            VStack(spacing: 4) {
                                Text("Portfolio Value")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                Text("$47,832.50")
                                    .font(.system(size: 34, weight: .bold, design: .rounded))
                            }
                            
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.up.right")
                                    .font(.caption)
                                Text("+$5,127.30")
                                    .fontWeight(.medium)
                                Text("(12.0%)")
                                    .font(.subheadline)
                            }
                            .foregroundStyle(.green)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                        
                        // Holdings
                        VStack(spacing: 0) {
                            Text("Holdings")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                                .padding(.bottom, 8)
                            
                            VStack(spacing: 1) {
                                MockHoldingRow(symbol: "AAPL", shares: "50.0000", value: "$12,450.00", gain: "+$2,150.00", percent: "+20.9%", isPositive: true)
                                MockHoldingRow(symbol: "GOOGL", shares: "25.0000", value: "$17,425.00", gain: "+$2,425.00", percent: "+16.2%", isPositive: true)
                                MockHoldingRow(symbol: "MSFT", shares: "30.0000", value: "$11,970.00", gain: "+$720.00", percent: "+6.4%", isPositive: true)
                                MockHoldingRow(symbol: "TSLA", shares: "20.0000", value: "$5,987.50", gain: "-$167.70", percent: "-2.7%", isPositive: false)
                            }
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal)
                        }
                    }
                }
                .background(Color(.systemGroupedBackground))
                
                // Footer
                HStack {
                    Text("Data by ")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    + Text("Twelve Data")
                        .font(.caption2)
                        .foregroundStyle(.blue)
                }
                .padding(.vertical, 8)
                .background(Color(.systemGroupedBackground))
            }
        }
    }
}

// MARK: - Screenshot 3: Add Holding

struct Screenshot3_AddHolding: View {
    var body: some View {
        ScreenshotFrame(
            headline: "Add Holdings\nEasily",
            subheadline: "Symbol, quantity & purchase price"
        ) {
            VStack(spacing: 0) {
                // Nav bar
                HStack {
                    Text("Cancel")
                        .foregroundStyle(.blue)
                    Spacer()
                    Text("Add Holding")
                        .font(.headline)
                    Spacer()
                    Text("Add")
                        .foregroundStyle(.blue)
                        .fontWeight(.semibold)
                }
                .padding()
                .background(Color(.systemBackground))
                
                // Form
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Text("Stock Details")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top, 24)
                            .padding(.bottom, 8)
                        
                        VStack(spacing: 1) {
                            MockFormRow(label: "Symbol", value: "NVDA")
                            MockFormRow(label: "Quantity", value: "15")
                            MockFormRow(label: "Purchase Price", value: "$450.00")
                        }
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                    }
                    
                    VStack(spacing: 0) {
                        VStack(spacing: 1) {
                            HStack {
                                Text("Include Purchase Date")
                                Spacer()
                                Toggle("", isOn: .constant(true))
                                    .labelsHidden()
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            
                            HStack {
                                Text("Purchase Date")
                                Spacer()
                                Text("Dec 15, 2025")
                                    .foregroundStyle(.blue)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                        .padding(.top, 24)
                        
                        Text("Purchase date is optional and for your reference only.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 32)
                            .padding(.top, 8)
                    }
                    
                    Spacer()
                }
                .background(Color(.systemGroupedBackground))
            }
        }
    }
}

// MARK: - Screenshot 4: Settings & About

struct Screenshot4_Settings: View {
    var body: some View {
        ScreenshotFrame(
            headline: "Your Data\nStays Private",
            subheadline: "Stored locally on your device"
        ) {
            VStack(spacing: 0) {
                // Nav bar
                HStack {
                    Spacer()
                    Text("Settings")
                        .font(.headline)
                    Spacer()
                    Text("Done")
                        .foregroundStyle(.blue)
                }
                .padding()
                .background(Color(.systemBackground))
                
                // Settings list
                VStack(spacing: 24) {
                    VStack(spacing: 1) {
                        MockSettingsRow(icon: "info.circle", label: "About", hasChevron: true)
                    }
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                    
                    VStack(spacing: 0) {
                        Text("Data Provider")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                        
                        VStack(spacing: 1) {
                            MockSettingsRow(icon: "chart.line.uptrend.xyaxis", label: "Twelve Data Website", hasChevron: false, isLink: true)
                        }
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                        
                        Text("Market data is provided by Twelve Data's free API tier.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 32)
                            .padding(.top, 8)
                    }
                    
                    VStack(spacing: 0) {
                        Text("Legal")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                        
                        VStack(spacing: 1) {
                            MockSettingsRow(icon: "hand.raised", label: "Privacy Policy", hasChevron: false, isLink: true)
                            MockSettingsRow(icon: "doc.text", label: "Terms of Use", hasChevron: false, isLink: true)
                        }
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding(.top, 8)
                .background(Color(.systemGroupedBackground))
            }
        }
    }
}

// MARK: - Screenshot Frame Component

struct ScreenshotFrame<Content: View>: View {
    let headline: String
    let subheadline: String
    let content: Content
    
    init(headline: String, subheadline: String, @ViewBuilder content: () -> Content) {
        self.headline = headline
        self.subheadline = subheadline
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.11, blue: 0.23),
                    Color(red: 0.08, green: 0.18, blue: 0.28),
                    Color(red: 0.05, green: 0.20, blue: 0.18)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Headline
                VStack(spacing: 8) {
                    Text(headline)
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(subheadline)
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.7))
                }
                .padding(.top, 60)
                
                // Phone frame
                content
                    .frame(width: 280, height: 580)
                    .clipShape(RoundedRectangle(cornerRadius: 40))
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.white.opacity(0.2), lineWidth: 8)
                    )
                    .shadow(color: .black.opacity(0.4), radius: 30, x: 0, y: 20)
                
                Spacer()
            }
        }
        .frame(width: 430, height: 932) // iPhone 15 Pro Max logical size
    }
}

// MARK: - Mock Components for Screenshots

struct MockHoldingRow: View {
    let symbol: String
    let shares: String
    let value: String
    let gain: String
    let percent: String
    let isPositive: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(symbol)
                    .font(.headline)
                    .fontWeight(.semibold)
                Text("\(shares) shares")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
                HStack(spacing: 2) {
                    Text(gain)
                    Text("(\(percent))")
                }
                .font(.caption)
                .foregroundStyle(isPositive ? .green : .red)
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

struct MockFormRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

struct MockSettingsRow: View {
    let icon: String
    let label: String
    var hasChevron: Bool = false
    var isLink: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(isLink ? .blue : .blue)
                .frame(width: 24)
            Text(label)
                .foregroundStyle(isLink ? .blue : .primary)
            Spacer()
            if hasChevron {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

// MARK: - Previews (Use these to capture screenshots)

#Preview("1 - Welcome") {
    Screenshot1_Welcome()
}

#Preview("2 - Portfolio") {
    Screenshot2_Portfolio()
}

#Preview("3 - Add Holding") {
    Screenshot3_AddHolding()
}

#Preview("4 - Settings") {
    Screenshot4_Settings()
}

