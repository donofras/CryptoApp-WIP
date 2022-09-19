//
//  LimitPriceView.swift
//  CryptoApp-WIP
//
//  Created by Denis Onofras on 19.09.2022.
//

import UIKit

final class LimitView: UIView {
    
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
    
    convenience init(type: LimitViewType) {
        self.init()
        typeLabel.text = type == .max ?  "max:" : "min:"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setValue(value: Double) {
        let formatedString = String(format: "%.3f", value)
        priceLabel.text = "$ \(formatedString)"
    }
    
    private func setupConstraints() {
        addSubviews(mainStackView)
        
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

enum LimitViewType {
    case min
    case max
}
