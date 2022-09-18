//
//  CoinChartViewModel.swift
//  CryptoApp-WIP
//
//  Created by Denis Onofras on 16.09.22.
//

import Combine
import Charts

final class CoinChartViewModel {

    @Published var selectedCoin: CoinModel
    @Published var chartData: CandleChartData!
    
    internal init(selectedCoin: CoinModel) {
        self.selectedCoin = selectedCoin
    }
    
    func getChartDataForCoin() {
        if let coinPriceHistory = getCoinPriceHistoryForLast(seconds: 30) {
            let dataEntryValues = prepareDataEntry(priceHistory: coinPriceHistory)
            let dataSetForChart = prepareDataSet(entries: dataEntryValues)
            chartData = CandleChartData(dataSet: dataSetForChart)
        }
    }
    
    private func getCoinPriceHistoryForLast(seconds: Int) -> [Double]? {
        
        if selectedCoin.priceHistory.elements.count >= seconds {
            
            var values = [Double]()
            selectedCoin.priceHistory.prefix(seconds).forEach { value in
                values.append(value)
            }
            
            return values
        }
        
        return nil
    }
    
    private func prepareDataEntry(priceHistory: [Double]) -> [CandleChartDataEntry] {
        var dataEntryValues = [CandleChartDataEntry]()
        
        //Because the framework does not provide all the necessary data for candle chart, some are randomly generated.
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
    
    private func prepareDataSet(entries: [ChartDataEntry]) -> CandleChartDataSet {
        let set = CandleChartDataSet(entries: entries, label: "Price")
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
}
