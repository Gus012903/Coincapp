import Dependencies
import Foundation
import XCTestDynamicOverlay

struct AssetsApiClient {
    var fetchAllAssets: () async throws -> [Asset]
}

enum NetworkingError: Error {
    case invalidURL
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        }
    }
}

extension AssetsApiClient: DependencyKey {
    static var liveValue: AssetsApiClient {
        .init(
            fetchAllAssets: {
                let urlSession = URLSession.shared
                
                guard let url = URL(string: "Aqui va la URL del Postman Mock Server") else {
                    throw NetworkingError.invalidURL
                }
                
                let (data, _) = try await urlSession.data(for: URLRequest(url: url))
                let assetsResponse = try JSONDecoder().decode(AssetsResponse.self, from: data)
                
                return assetsResponse.data
            }
        )
    }
    
    static var previewValue: AssetsApiClient {
        .init(
            fetchAllAssets: {[
                .init(
                    id: "bitcoin",
                    name: "Bitcoin",
                    symbol: "BTC",
                    priceUsd: "89111121.2828",
                    changePercent24Hr: "8.993939392"
                ),
                .init(
                    id: "ethereum",
                    name: "Ethereum",
                    symbol: "ETH",
                    priceUsd: "1289.284848",
                    changePercent24Hr: "-1.2333333333"
                ),
                .init(
                    id: "solana",
                    name: "Solana",
                    symbol: "SOL",
                    priceUsd: "500.29393939",
                    changePercent24Hr: "9.8282822"
                )
            ]}
        )
    }
    
    static var testValue: AssetsApiClient {
        .init(fetchAllAssets: {
            XCTFail("AssetsApiClient.fetchAllAssets is unimplemented")
//            reportIssue("AssetsApiClient.fetchAllAssets is unimplemented")
            return []
        })
    }
}

extension DependencyValues {
    var assetsApiClient: AssetsApiClient {
        get { self[AssetsApiClient.self] }
        set { self[AssetsApiClient.self] = newValue }
    }
}
