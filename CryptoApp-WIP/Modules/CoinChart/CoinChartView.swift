//
//  CoindChartView.swift
//  CryptoApp-WIP
//
//  Created by Denis Onofras on 16.09.22.
//

import UIKit
import Charts
import Kingfisher

final class CoinChartView: UIView {
    
    lazy var coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    lazy var coinTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 45, weight: .bold)
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var chartView: CandleStickChartView = {
        let chartView = CandleStickChartView()
        chartView.legend.enabled = false
        chartView.rightAxis.enabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.isUserInteractionEnabled = false
        chartView.xAxis.labelPosition = .bottom
        
        return chartView
    }()
    
    let data: [Double] = [2.4,3.6,6.0,3.4,2.4,3.6,6.0,3.4,2.4,3.6,6.0,3.4,3.6,6.0,3.4,2.4,3.6,6.0,3.4,2.4,3.6,6.0,3.4,3.6,6.0,3.4,2.4,3.6,6.0,3.4,2.4,3.6,6.0,3.4]
    
    private func prepareChartDataEntry(priceHistory: [Double]) -> [ChartDataEntry] {
        var dataEntryValues = [CandleChartDataEntry]()
        
        for i in 0..<priceHistory.count {
            let val = priceHistory[i]
            let high = Double.random(in: 6...8)
            let low = Double.random(in: 6...8)
            let open = Double.random(in: 1...6)
            let close = Double.random(in: 1...6)
            let even = (i / 2) == 0
            
            let entry = CandleChartDataEntry(x: Double(i),
                                             shadowH: val + high,
                                             shadowL: val - low,
                                             open: even ? val + open : val - open,
                                             close: even ? val - close : val + close)
            
            dataEntryValues.append(entry)
        }
        
        return dataEntryValues
    }
    
    private func prepareCandleChartDataSet(entryValues: [ChartDataEntry]) -> CandleChartDataSet {
        let set = CandleChartDataSet(entries: entryValues, label: "Price")
        set.axisDependency = .left
        set.drawIconsEnabled = false
        set.drawValuesEnabled = false
        set.shadowColor = .darkGray
        set.shadowWidth = 0.7
        set.decreasingColor = .redColor
        set.decreasingFilled = true
        set.increasingColor = .greenColor
        set.increasingFilled = true
        set.neutralColor = .blue
        
        return set
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupConstraints()
        
        coinImageView.kf.setImage(
            with: URL(string: "https://www.cryptocompare.com/media/37746243/ltc.png")!,
            options: kingfisherOptions)
        
        let entry = prepareChartDataEntry(priceHistory: data)
        let datasource = prepareCandleChartDataSet(entryValues: entry)
        chartView.data = CandleChartData(dataSet: datasource)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    private func setupConstraints() {
        backgroundColor = .white
        addSubviews(coinImageView, coinTitleLabel, chartView)
        
        coinImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.snp.topMargin)
            $0.size.equalTo(100)
        }
        
        coinTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.top.equalTo(coinImageView.snp.bottom).offset(15)
        }
        
        chartView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(chartView.snp.width)
            $0.top.equalTo(coinTitleLabel.snp.bottom).offset(50)
        }
    }
}
