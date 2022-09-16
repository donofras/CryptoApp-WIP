//
//  CoinChartVC.swift
//  CryptoApp-WIP
//
//  Created by Denis Onofras on 16.09.22.
//

import UIKit

class CoinChartVC: UIViewController {
    
    private var coinChartView: CoinChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chart"
        coinChartView = CoinChartView()
    }
    
    override func loadView() {
        self.view = coinChartView
    }
}
