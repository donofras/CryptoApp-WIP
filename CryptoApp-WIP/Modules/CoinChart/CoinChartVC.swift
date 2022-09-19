//
//  CoinChartVC.swift
//  CryptoApp-WIP
//
//  Created by Denis Onofras on 16.09.22.
//

import UIKit
import Combine
import Charts

final class CoinChartVC: UIViewController {
    
    private var coinChartView: CoinChartView!
    private var viewModel: CoinChartViewModel!
    private var subscriptions = Set<AnyCancellable>()
    
    convenience init(viewModel: CoinChartViewModel) {
        self.init()
        self.viewModel = viewModel
        self.title = viewModel.selectedCoin.code
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinChartView = CoinChartView()
        setupBindings()
    }
    
    override func loadView() {
        self.view = coinChartView
    }
    
    private func setupBindings() {
        viewModel.$selectedCoin.sink { [weak self] coin in
            guard let self = self else { return }
            
            self.coinChartView.coinTitleLabel.text = coin.name
            self.viewModel.getChartData()
            if let coinImageURLString = coin.imageStringURL, let imageURL = URL(string: coinImageURLString) {
                self.coinChartView.coinImageView.kf.setImage(
                    with: imageURL,
                    options: kingfisherOptions)
            }
        }
        .store(in: &subscriptions)
        
        viewModel.$chartData.sink { [weak self] dataSet in
            guard let self = self else { return }
            
            self.coinChartView.chartView.data = dataSet
        }
        .store(in: &subscriptions)
    }
}
