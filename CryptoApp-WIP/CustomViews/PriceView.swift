//
//  PriceView.swift
//  CryptoApp-WIP
//
//  Created by Denis Onofras on 16.09.22.
//

import UIKit

final class PriceView: UIView {
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .regular)
        
        return label
    }()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }
    
    func setValue(value: Double, trend: PriceTrend) {
        let formatedString = String(format: "%.3f", value)
        priceLabel.text = "$ \(formatedString)"
        
        switch trend {
        case .increased:
            setBackgroundCollor(color: .greenColor)
            priceLabel.textColor = .white
        case .decreased:
            setBackgroundCollor(color: .redColor)
            priceLabel.textColor = .white
        case .none:
            setBackgroundCollor(color: .clear)
            priceLabel.textColor = .black
        }
    }
    
    private func setupLayout() {
        backgroundColor = .redColor
        clipsToBounds = true
        layer.cornerRadius = 10
        
        addSubviews(priceLabel)
        
        priceLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalToSuperview().inset(10)
        }
    }
    
    private func setBackgroundCollor(color: UIColor) {
        UIView.animate(withDuration: 0.7, delay: 0, animations: {
            self.backgroundColor = color
        })
    }
}
