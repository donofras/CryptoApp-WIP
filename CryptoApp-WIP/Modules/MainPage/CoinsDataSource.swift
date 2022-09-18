//
//  CoinsDataSource.swift
//  CryptoApp-WIP
//
//  Created by Denis Onofras on 19.09.2022.
//

import UIKit

final class CoinsDataSource: UITableViewDiffableDataSource<MainPageVC.Section, CoinModel> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
}
