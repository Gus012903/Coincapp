import Foundation

struct Asset: Decodable, Identifiable, Equatable {
    let id: String
    let name: String
    let symbol: String
    let priceUsd: String
    let changePercent24Hr: String
    
}

