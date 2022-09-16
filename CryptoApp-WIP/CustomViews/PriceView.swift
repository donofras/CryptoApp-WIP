//
//  PriceView.swift
//  CryptoApp-WIP
//
//  Created by Denis Onofras on 16.09.22.
//

import UIKit

final class PriceView: UIView {

    func setBackgroundCollor(color: UIColor) {
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.backgroundColor = color
        })
    }
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "$ 12345"
        
        return label
    }()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
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
}

enum LimitPriceViewType {
    case min
    case max
}

final class LimitPriceView: UIView {
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 9, weight: .thin)
        
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grayColor
        label.font = .systemFont(ofSize: 10, weight: .regular)
        
        return label
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [typeLabel, priceLabel])
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 3
        
        return stackView
    }()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
        
        setupConstraints()
    }
    
    convenience init(type: LimitPriceViewType) {
        self.init()
        typeLabel.text = type == .max ?  "max:" : "min:"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Private functions
    private func setupConstraints() {
        addSubviews(mainStackView)
        
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Internal functions
    func setValue(value: Double) {
        let formatedString = String(format: "%.3f", value)
        priceLabel.text = "$ \(formatedString)"
    }
}
