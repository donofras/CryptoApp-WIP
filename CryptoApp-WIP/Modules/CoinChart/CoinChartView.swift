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
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupConstraints()
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
            $0.size.equalTo(Layout.imageSize)
        }
        
        coinTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.top.equalTo(coinImageView.snp.bottom).offset(Layout.titleTopOffses)
        }
        
        chartView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Layout.chartInset)
            $0.height.equalTo(chartView.snp.width)
            $0.top.equalTo(coinTitleLabel.snp.bottom).offset(Layout.charTopOffset)
        }
    }
}

extension CoinChartView {
    private enum Layout {
        static let imageSize: CGFloat = 100.0
        static let titleTopOffses: CGFloat = 15.0
        static let chartInset: CGFloat = 10.0
        static let charTopOffset: CGFloat = 50.0
    }
}
