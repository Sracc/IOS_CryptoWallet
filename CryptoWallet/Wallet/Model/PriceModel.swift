//
//  PriceModel.swift
//  Wallet
//
//  Created by Kaitao Tan on 18/5/2022.
//

import Foundation

// MARK: - Price
struct Price: Identifiable, Codable {
    let id: String
    let price24H, volume24H, lastTradePrice: Double

    enum CodingKeys: String, CodingKey {
        case id = "symbol"
        case price24H = "price_24h"
        case volume24H = "volume_24h"
        case lastTradePrice = "last_trade_price"
    }
    
    func getPercent() -> String {
        let percentChange = ((lastTradePrice - price24H)/price24H) * 100
        let percent = String(format: "%.2f", percentChange)
        return percent
    }
}

