//
//  AppDelegate.swift
//  Fetch
//
//  Created by Lotanna Igwe-Odunze on 11/8/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        
        let mealsListViewModel = MealsViewModel()
        window?.rootViewController = MealsListController(viewModel: mealsListViewModel)
        window?.makeKeyAndVisible()
        return true
    }
}
