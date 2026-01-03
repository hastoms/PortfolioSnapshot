//
//  PortfolioSnapshotApp.swift
//  PortfolioSnapshot
//
//  Created by Tom Stevenson on 1/1/26.
//

import SwiftUI
import SwiftData

@main
struct PortfolioSnapshotApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Holding.self,
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            PortfolioView()
        }
        .modelContainer(sharedModelContainer)
    }
}
