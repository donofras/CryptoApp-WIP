//
//  CointTVC.swift
//  CryptoApp-WIP
//
//  Created by Denis Onofras on 16.09.22.
//

import UIKit
import Combine
import Kingfisher

final class CointTVC: UITableViewCell {
    
    static let identifier = "CointTVC"
    
    @Published var coin: CoinModel!
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Bitcoin"
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return label
    }()
    
    lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grayColor
        label.font = .systemFont(ofSize: 16, weight: .thin)
        label.text = "BTC"
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    private lazy var titlesStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [titleLabel, codeLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.distribution = .fill
        stackView.spacing = Layout.spacing
        
        return stackView
    }()
    
    private lazy var minPriceView = LimitView(type: .min)
    private lazy var maxPriceView = LimitView(type: .max)
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCoin(coin: CoinModel) {
        self.coin = coin
        setupBindings()
    }
    
    private func setupBindings() {
        
        RealmManager.shared().$updatedCoin.sink { [weak self] receivedCoin in
            guard let self = self else { return }
            
            if let coin = receivedCoin {
                if self.coin.name == coin.name { self.coin = coin }
            }
        }
        .store(in: &subscriptions)
        
        $coin.sink { [weak self] receivedCoin in
            guard let self = self else { return }
            
            if let coin = receivedCoin {
                if let imageURLString = coin.imageStringURL,
                   let imageURL = URL(string: imageURLString) {
                    self.coinImageView.kf.setImage(
                        with: imageURL,
                        options: kingfisherOptions)
                }
                
                self.titleLabel.text = coin.name
                self.codeLabel.text = coin.code
                
                let trend = PriceTrend(rawValue: coin.priceTrend) ?? .none
                self.priceView.setValue(value: coin.price, trend: trend)
                self.minPriceView.setValue(value: coin.minPrice)
                self.maxPriceView.setValue(value: coin.maxPrice)
            }
        }
        .store(in: &subscriptions)
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
