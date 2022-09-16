//
//  MainPageVC.swift
//  CryptoApp-WIP
//
//  Created by Denis Onofras on 16.09.22.
//

import UIKit
import SnapKit

final class MainPageVC: UIViewController {
    
    private var mainView: MainPageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Market"
        
        mainView = MainPageView(frame: .zero)
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }
    
    override func loadView() {
        self.view = mainView
    }
}

extension MainPageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CointTVC.identifier, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        self.navigationController?.pushViewController(CoinChartVC(), animated: true)
    }
}
