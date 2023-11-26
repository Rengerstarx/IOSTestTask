import Foundation

struct Crypto: Codable, Equatable {
    static func == (lhs: Crypto, rhs: Crypto) -> Bool {
        return lhs.id == rhs.id &&
            lhs.symbol == rhs.symbol &&
            lhs.name == rhs.name &&
            lhs.image == rhs.image &&
            lhs.currentPrice == rhs.currentPrice &&
            lhs.marketCap == rhs.marketCap &&
            lhs.marketCapRank == rhs.marketCapRank &&
            lhs.fullyDilutedValuation == rhs.fullyDilutedValuation &&
            lhs.totalVolume == rhs.totalVolume &&
            lhs.high24H == rhs.high24H &&
            lhs.low24H == rhs.low24H &&
            lhs.priceChange24H == rhs.priceChange24H &&
            lhs.priceChangePercentage24H == rhs.priceChangePercentage24H &&
            lhs.marketCapChange24H == rhs.marketCapChange24H &&
            lhs.marketCapChangePercentage24H == rhs.marketCapChangePercentage24H &&
            lhs.circulatingSupply == rhs.circulatingSupply &&
            lhs.totalSupply == rhs.totalSupply &&
            lhs.maxSupply == rhs.maxSupply &&
            lhs.ath == rhs.ath &&
            lhs.athChangePercentage == rhs.athChangePercentage &&
            lhs.athDate == rhs.athDate &&
            lhs.atl == rhs.atl &&
            lhs.atlChangePercentage == rhs.atlChangePercentage &&
            lhs.atlDate == rhs.atlDate &&
            lhs.roi == rhs.roi &&
            lhs.lastUpdated == rhs.lastUpdated &&
            lhs.priceChangePercentage1HInCurrency == rhs.priceChangePercentage1HInCurrency
    }
    
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank, fullyDilutedValuation, totalVolume: Int
    let high24H, low24H, priceChange24H, priceChangePercentage24H: Double
    let marketCapChange24H, marketCapChangePercentage24H, circulatingSupply, totalSupply: Double
    let maxSupply: Double?
    let ath, athChangePercentage: Double
    let athDate: String
    let atl, atlChangePercentage: Double
    let atlDate: String
    let roi: Roi?
    let lastUpdated: String
    let priceChangePercentage1HInCurrency: Double

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case roi
        case lastUpdated = "last_updated"
        case priceChangePercentage1HInCurrency = "price_change_percentage_1h_in_currency"
    }
}

// MARK: - Roi
struct Roi: Codable, Equatable {
    let times: Double
    let currency: String
    let percentage: Double
}