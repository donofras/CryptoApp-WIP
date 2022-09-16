//
//  MainPageView.swift
//  CryptoApp-WIP
//
//  Created by Denis Onofras on 16.09.22.
//

import UIKit

final class MainPageView: UIView {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 60
        tableView.register(CointTVC.self, forCellReuseIdentifier: CointTVC.identifier)
        
        return tableView
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
        addSubviews(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
