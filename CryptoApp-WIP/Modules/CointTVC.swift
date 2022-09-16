//
//  CointTVC.swift
//  CryptoApp-WIP
//
//  Created by Denis Onofras on 16.09.22.
//

import UIKit
import Kingfisher

final class CointTVC: UITableViewCell {
    
    static let identifier = "CointTVC"
    
    private lazy var coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    lazy var coinTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Bitcoin"
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return label
    }()
    
    lazy var coinCodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grayColor
        label.font = .systemFont(ofSize: 16, weight: .thin)
        label.text = "BTC"
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    private lazy var titlesStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [coinTitleLabel, coinCodeLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.distribution = .fill
        stackView.spacing = Layout.spacing
        
        return stackView
    }()
    
    private lazy var minPriceView = LimitPriceView(type: .min)
    private lazy var maxPriceView = LimitPriceView(type: .max)
    
    private lazy var pricesStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [minPriceView, maxPriceView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = Layout.spacing
        
        return stackView
    }()
    
    private lazy var midleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titlesStackView, pricesStackView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Layout.spacing
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return stackView
    }()
    
    private lazy var priceView = PriceView()
    
    private lazy var mainStackView: UIStackView = {
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        let stackView = UIStackView(arrangedSubviews: [coinImageView, midleStackView, spacer, priceView])
        stackView.spacing = Layout.spacing
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var bottomSeparatorView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .separatorColor
        
        return lineView
    }()
      
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        setupConstraints()
        coinImageView.kf.setImage(
            with: URL(string: "https://www.cryptocompare.com/media/37746243/ltc.png")!,
            options: kingfisherOptions)
        
        minPriceView.setValue(value: 1234.0)
        maxPriceView.setValue(value: Double.random(in: 3000...12000))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.priceView.setBackgroundCollor(color: .greenColor)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        backgroundColor = .white
        addSubviews(mainStackView, bottomSeparatorView)
        
        mainStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(Layout.vInset)
            $0.width.equalToSuperview().inset(Layout.hInset)
        }
        
        coinImageView.snp.makeConstraints {
            $0.size.equalTo(Layout.imageSize)
        }
        
        bottomSeparatorView.snp.makeConstraints {
            $0.centerX.bottom.equalToSuperview()
            $0.width.equalToSuperview().inset(Layout.hInset)
            $0.height.equalTo(1)
        }
    }
}

extension CointTVC {
    private enum Layout {
        static let spacing: CGFloat = 10.0
        static let imageSize: CGFloat = 24
        static let hInset: CGFloat = 20.0
        static let vInset: CGFloat = 10.0
    }
}

// TODO: Move to constants!
let imageTransitionDuration: TimeInterval = 0.3
let retryOfFailDownloadImage: Int = 3
let kingfisherOptions: KingfisherOptionsInfo = [
    .scaleFactor(UIScreen.main.scale),
    .transition(.fade(imageTransitionDuration)),
    .cacheOriginalImage,
    .retryStrategy(DelayRetryStrategy(maxRetryCount: retryOfFailDownloadImage))
]
