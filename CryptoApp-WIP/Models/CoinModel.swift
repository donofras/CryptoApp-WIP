//
//  CoinModel.swift
//  CryptoApp-WIP
//
//  Created by Denis Onofras on 17.09.2022.
//

import RealmSwift

final class CoinModel: Object {
    
    @Persisted(primaryKey: true) var code: String
    @Persisted var name: String
    @Persisted var imageStringURL: String?
    @Persisted var minPrice: Double
    @Persisted var maxPrice: Double
    @Persisted var priceHistory: List<Double>
    @Persisted var priceTrend: String = PriceTrend.none.rawValue
    @Persisted var price: Double { didSet { setLimitPrices() } }
    
    convenience init(code: String,
                     name: String,
                     price: Double,
                     minPrice: Double,
                     maxPrice: Double,
                     imageURL: String?) {
        self.init()
        self.code = code
        self.name = name
        self.price = price
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.imageStringURL = imageURL
    }
    
    func updatePrice(newPrice: Double) {
        setPriceTrend(newPrice: newPrice)
        price = newPrice
    }
    
    private func setPriceTrend(newPrice: Double) {
        if newPrice > price {
            priceTrend = PriceTrend.increased.rawValue
        } else if newPrice < price {
            priceTrend = PriceTrend.decreased.rawValue
        } else {
            priceTrend = PriceTrend.none.rawValue
        }
    }

    private func setLimitPrices() {
        if price < minPrice {
            minPrice = price
        }
        
        if price > maxPrice {
            maxPrice = price
        }
    }
}

enum PriceTrend: String {
    case increased
    case decreased
    case none
}
