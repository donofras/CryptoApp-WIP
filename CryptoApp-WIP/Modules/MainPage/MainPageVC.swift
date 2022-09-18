//
//  MainPageVC.swift
//  CryptoApp-WIP
//
//  Created by Denis Onofras on 16.09.22.
//

import UIKit
import Combine
import SnapKit

final class MainPageVC: UIViewController {
    
    enum Section: Hashable {
        case main
    }
    
    private var mainView: MainPageView!
    private var viewModel: MainPageViewModel!
    private var subscriptions = Set<AnyCancellable>()
    private lazy var dataSource = viewModel.createDataSource(for: self.mainView)
    
    convenience init(viewModel: MainPageViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Market"
        
        mainView = MainPageView(frame: .zero)
        mainView.tableView.delegate = self
        viewModel.getCoinsFromAPI()
        setupBindings()
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    private func setupBindings() {
        viewModel.$coinsArray.sink(receiveValue: { [weak self] coins in
            guard let self = self else { return }
            
            let snapshot = self.viewModel.createSnapshot(coins: coins)
            self.dataSource.apply(snapshot)
        }).store(in: &subscriptions)
    }
    
    private func pushCoinChartVC(coin: CoinModel) {
        let vm = CoinChartViewModel(selectedCoin: coin)
        let chartVC = CoinChartVC(viewModel: vm)
        self.navigationController?.pushViewController(chartVC, animated: true)
    }
}

extension MainPageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCoind = dataSource.itemIdentifier(for: indexPath) else { return }
        self.pushCoinChartVC(coin: selectedCoind)
    }
}
