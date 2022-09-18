//
//  CoinChartVC.swift
//  CryptoApp-WIP
//
//  Created by Denis Onofras on 16.09.22.
//

import UIKit
import Combine
import Charts

class CoinChartVC: UIViewController {
    
    private var coinChartView: CoinChartView!
    private var viewModel: CoinChartViewModel!
    private var subscriptions = Set<AnyCancellable>()
    
    convenience init(viewModel: CoinChartViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chart"
        
        coinChartView = CoinChartView()
        setupBindings()
    }
    
    override func loadView() {
        self.view = coinChartView
    }
    
    private func setupBindings() {
        viewModel.$selectedCoin.sink(receiveValue: { [weak self] coin in
            guard let self = self else { return }

            self.coinChartView.coinTitleLabel.text = coin.code
            self.viewModel.getChartDataForCoin()
            if let coinImageURLString = coin.imageStringURL, let imageURL = URL(string: coinImageURLString) {
                self.coinChartView.coinImageView.kf.setImage(
                    with: imageURL,
                    options: kingfisherOptions)
            }
        }).store(in: &subscriptions)
        
        
        viewModel.$chartData.sink(receiveValue: { [weak self] dataSet in
            guard let self = self else { return }
            
            self.coinChartView.chartView.data = dataSet
        }).store(in: &subscriptions)
    }
}
