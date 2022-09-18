//
//  AppDelegate.swift
//  CryptoApp-WIP
//
//  Created by Denis Onofras on 16.09.22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let viewModel = MainPageViewModel()
        let mainVC = MainPageVC(viewModel: viewModel)
        
        let rootNC = UINavigationController(rootViewController: mainVC)
        rootNC.navigationBar.prefersLargeTitles = true
        rootNC.navigationBar.tintColor = .black
        
        self.window?.rootViewController = rootNC
        self.window?.makeKeyAndVisible()
        return true
    }
}

