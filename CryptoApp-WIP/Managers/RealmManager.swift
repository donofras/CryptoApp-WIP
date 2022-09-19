//
//  RealmManager.swift
//  CryptoApp-WIP
//
//  Created by Denis Onofras on 17.09.2022.
//

import Combine
import RealmSwift
import CryptoAPI

final class RealmManager {
    
    private static let sharedInstance = RealmManager()
    
    var isEmpty: Bool {
        if let realm = realm {
            return realm.objects(CoinModel.self).isEmpty
        }
        
        return true
    }
    
    var receivedCoinsFromAPI: [Coin] = [] {
        didSet {
            if isEmpty {
                addCoinsToDataBase(coins: receivedCoinsFromAPI)
            } else {
                updateCoinsValues(coins: receivedCoinsFromAPI)
            }
            
            if let dataBaseCoinObjects = getCoinObjects() {
                dataBaseCoins = getArrayOfModels(result: dataBaseCoinObjects)
            }
        }
    }
    
    private func getCoinObjects() -> Results<CoinModel>? {
        return realm?.objects(CoinModel.self)
    }

    @Published private(set) var updatedCoin: CoinModel? = nil
    @Published private(set) var dataBaseCoins: [CoinModel] = []
    
    private var realm: Realm?
    private var timer = Timer()
    
    class func shared() -> RealmManager {
        return sharedInstance
    }

    init() {
        realm = try? Realm()
    }
    
    func updateCoinValue(coin: Coin, isAppLaunchUpdate: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
  
            if let dataBaseCoin = self.getCoinObjects()?.first(where: { $0.code == coin.code }) {
                try? self.realm?.write {
                    dataBaseCoin.updatePrice(newPrice: coin.price)
                }
                
                if !isAppLaunchUpdate {
                    self.updatedCoin = dataBaseCoin
                }
            }
        }
    }
    
    func startPriceMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            
            self.updateCoinsPriceHistory()
        })
    }
    
    func getCoin(code: String) -> CoinModel? {
        return getCoinObjects()?.first(where: { $0.code == code })
    }

    private func addCoinsToDataBase(coins: [Coin]) {
        let realmInstance = realm
        let coinsDataBaseModels = createCoinDataBaseModels(from: coins)
        
        try? realmInstance?.write {
            realmInstance?.add(coinsDataBaseModels)
        }
    }
    
    private func updateCoinsValues(coins: [Coin]) {
        coins.forEach {
            updateCoinValue(coin: $0)
        }
    }
    
    private func getArrayOfModels(result: Results<CoinModel>) -> [CoinModel] {
        var array: [CoinModel] = []
        for i in 0 ..< result.count {
            array.append(result[i])
        }
        
        return array
    }

    private func createCoinDataBaseModels(from coins: [Coin]) -> [CoinModel] {
        var coinDataBaseModels = [CoinModel]()
        
        coins.forEach { coin in
            let coinDataBaseModel = CoinModel(code: coin.code,
                                              name: coin.name,
                                              price: coin.price,
                                              minPrice: coin.price,
                                              maxPrice: coin.price,
                                              imageURL: coin.imageUrl)
            
            coinDataBaseModels.append(coinDataBaseModel)
        }
        
        return coinDataBaseModels
    }
    
    private func updateCoinsPriceHistory() {
        getCoinObjects()?.forEach { coinObject in
            try? realm?.write {
                coinObject.priceHistory.append(coinObject.price)
            }
        }
    }
}
