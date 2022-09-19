//
//  MainPageViewModel.swift
//  CryptoApp-WIP
//
//  Created by Denis Onofras on 16.09.22.
//

import UIKit
import CryptoAPI
import Combine

final class MainPageViewModel {
    
    typealias CoinsDataSourceSnapshot = NSDiffableDataSourceSnapshot<MainPageVC.Section, CoinModel>
    
    private var cryptoAPI: Crypto!
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var coins: [Coin] = []
    @Published var coinsArray: [CoinModel] = []
    
    init() {
        cryptoAPI = Crypto(delegate: self)
        setupBindings()
    }
    
    func getCoinsFromAPI() {
        cryptoAPI.connect().publisher.sink { result in
            switch result {
            case .failure(let error):
                fatalError(error.localizedDescription)
            case .finished:
                break
            }
        } receiveValue: { [weak self] isConnected in
            guard let self = self else { return }
            if isConnected {
                self.coins = self.cryptoAPI.getAllCoins()
            } else {
                self.getCoinsFromAPI()
            }
        }
        .store(in: &subscriptions)
    }
    
    func createDataSource(for view: MainPageView) -> CoinsDataSource {
        let dataSource = CoinsDataSource(tableView: view.tableView) { tableView, indexPath, coin in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CointTVC.identifier, for: indexPath) as? CointTVC else {
                return UITableViewCell()
            }
            cell.setCoin(coin: coin)
            return cell
        }
        dataSource.defaultRowAnimation = .fade
        
        return dataSource
    }
    
    func createSnapshot(coins: [CoinModel]) -> CoinsDataSourceSnapshot {
        var snapshot = CoinsDataSourceSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(coins, toSection: .main)
        
        return snapshot
    }
    
    private func setupBindings() {
        $coins.sink { receivedCoins in
            RealmManager.shared().receivedCoinsFromAPI = receivedCoins
        }
        .store(in: &subscriptions)
        
        RealmManager.shared().$dataBaseCoins.sink { [weak self] receivedValue in
            guard let self = self else { return }
            
            self.coinsArray = receivedValue
            RealmManager.shared().startPriceMonitoring()
        }
        .store(in: &subscriptions)
    }
}

// MARK: - CryptoDelegate
extension MainPageViewModel: CryptoDelegate {
    
    func cryptoAPIDidConnect() {}
    
    func cryptoAPIDidUpdateCoin(_ coin: Coin) {
        RealmManager.shared().updateCoinValue(coin: coin, isAppLaunchUpdate: false)
    }
    
    func cryptoAPIDidDisconnect() {}
}
