//
//  AppDelegate.swift
//  ImageLoader
//
//  Created by Динара Аминова on 10.12.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        
        let vc = PhotoListViewController()
        let nc = UINavigationController(rootViewController: vc)
        nc.navigationBar.backgroundColor = .white
        nc.navigationBar.tintColor = UIColor.black
        nc.navigationBar.prefersLargeTitles = true
        nc.navigationItem.largeTitleDisplayMode = .always
        nc.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        window?.rootViewController = nc
        window?.makeKeyAndVisible()
        
        return true
    }
}

