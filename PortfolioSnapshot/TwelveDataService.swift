//
//  TwelveDataService.swift
//  PortfolioSnapshot
//
//  Created by Tom Stevenson on 1/2/26.
//

import Foundation
import Combine

// MARK: - API Response Models

struct TwelveDataQuote: Codable {
    let symbol: String?
    let name: String?
    let close: String?
    let previousClose: String?
    let change: String?
    let percentChange: String?
    let timestamp: Int?
    
    // Error handling
    let status: String?
    let message: String?
    let code: Int?
    
    enum CodingKeys: String, CodingKey {
        case symbol, name, close, timestamp, status, message, code
        case previousClose = "previous_close"
        case change
        case percentChange = "percent_change"
    }
    
    var price: Double? {
        guard let closeStr = close else { return nil }
        return Double(closeStr)
    }
    
    var isError: Bool {
        status == "error"
    }
}

// MARK: - Service Errors

enum TwelveDataError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case apiError(String)
    case rateLimitExceeded
    case invalidSymbol(String)
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid request URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError:
            return "Failed to parse response"
        case .apiError(let message):
            return message
        case .rateLimitExceeded:
            return "API rate limit exceeded. Please wait a moment."
        case .invalidSymbol(let symbol):
            return "Invalid symbol: \(symbol)"
        case .noData:
            return "No price data available"
        }
    }
}

// MARK: - Twelve Data Service

@MainActor
class TwelveDataService: ObservableObject {
    // API key is loaded from Secrets.swift (which is gitignored)
    // See Secrets.swift.example for setup instructions
    private let apiKey = Secrets.twelveDataAPIKey
    private let baseURL = "https://api.twelvedata.com"
    
    @Published var isLoading = false
    @Published var lastError: TwelveDataError?
    
    // Cache to avoid hitting rate limits
    private var priceCache: [String: (price: Double, timestamp: Date)] = [:]
    private let cacheValiditySeconds: TimeInterval = 60 // 1 minute cache
    
    /// Fetches the current price for a single symbol
    func fetchPrice(for symbol: String) async throws -> Double {
        let cleanSymbol = symbol.uppercased().trimmingCharacters(in: .whitespaces)
        
        // Check cache first
        if let cached = priceCache[cleanSymbol],
           Date().timeIntervalSince(cached.timestamp) < cacheValiditySeconds {
            return cached.price
        }
        
        guard let url = URL(string: "\(baseURL)/quote?symbol=\(cleanSymbol)&apikey=\(apiKey)") else {
            throw TwelveDataError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Check for rate limiting
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 429 {
                throw TwelveDataError.rateLimitExceeded
            }
            
            let quote = try JSONDecoder().decode(TwelveDataQuote.self, from: data)
            
            // Check for API errors
            if quote.isError {
                if quote.code == 429 {
                    throw TwelveDataError.rateLimitExceeded
                }
                if let message = quote.message, message.contains("not found") {
                    throw TwelveDataError.invalidSymbol(cleanSymbol)
                }
                throw TwelveDataError.apiError(quote.message ?? "Unknown API error")
            }
            
            guard let price = quote.price else {
                throw TwelveDataError.noData
            }
            
            // Update cache
            priceCache[cleanSymbol] = (price, Date())
            
            return price
            
        } catch let error as TwelveDataError {
            throw error
        } catch let error as DecodingError {
            throw TwelveDataError.decodingError(error)
        } catch {
            throw TwelveDataError.networkError(error)
        }
    }
    
    /// Updates prices for multiple holdings
    /// Uses individual requests to stay within free tier limits
    func updatePrices(for holdings: [Holding]) async {
        isLoading = true
        lastError = nil
        
        for holding in holdings {
            do {
                let price = try await fetchPrice(for: holding.symbol)
                holding.currentPrice = price
                holding.lastUpdated = Date()
                
                // Small delay between requests to respect rate limits
                // Free tier: 8 API credits/minute, 800/day
                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
                
            } catch let error as TwelveDataError {
                lastError = error
                // Continue with other holdings even if one fails
            } catch {
                lastError = .networkError(error)
            }
        }
        
        isLoading = false
    }
    
    /// Clears the price cache
    func clearCache() {
        priceCache.removeAll()
    }
}

