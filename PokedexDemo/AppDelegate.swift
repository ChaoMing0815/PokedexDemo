//
//  AppDelegate.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/17.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // 限制畫面鎖定在縱向，避免手機翻轉導致佈局錯誤
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
           return .portrait
       }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let viewController = HomePageViewController.init() /*AllPokemonListViewController.init()*/
        let navigationController = makeNavigationController(with: viewController)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func makeNavigationController(with rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.navigationBar.tintColor = UIColor.white
        navigationController.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        return navigationController
    }
}
