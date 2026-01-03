//
//  Holding.swift
//  PortfolioSnapshot
//
//  Created by Tom Stevenson on 1/2/26.
//
import Foundation
import SwiftData

@Model
class Holding {
    var symbol: String
    var quantity: Double
    var purchasePrice: Double
    var purchaseDate: Date?
    var currentPrice: Double?
    var lastUpdated: Date?
    var createdAt: Date
    
    init(
        symbol: String,
        quantity: Double,
        purchasePrice: Double,
        purchaseDate: Date? = nil
    ) {
        self.symbol = symbol.uppercased().trimmingCharacters(in: .whitespaces)
        self.quantity = (quantity * 10000).rounded() / 10000 // Round to 4 decimals
        self.purchasePrice = purchasePrice
        self.purchaseDate = purchaseDate
        self.currentPrice = nil
        self.lastUpdated = nil
        self.createdAt = Date()
    }
    
    // MARK: - Computed Properties
    
    var costBasis: Double {
        quantity * purchasePrice
    }
    
    var marketValue: Double? {
        guard let price = currentPrice else { return nil }
        return quantity * price
    }
    
    var gainLoss: Double? {
        guard let value = marketValue else { return nil }
        return value - costBasis
    }
    
    var gainLossPercent: Double? {
        guard let gain = gainLoss, costBasis > 0 else { return nil }
        return (gain / costBasis) * 100
    }
    
    var displaySymbol: String {
        symbol.uppercased()
    }
}
