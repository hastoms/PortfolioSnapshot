//
//  ContentView.swift
//  PortfolioSnapshot
//
//  Created by Tom Stevenson on 1/1/26.
//

import SwiftUI
import SwiftData

// This file is kept for reference but the main view is now PortfolioView.swift
// You can safely delete this file from your Xcode project.

struct ContentView: View {
    var body: some View {
        PortfolioView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Holding.self, inMemory: true)
}
