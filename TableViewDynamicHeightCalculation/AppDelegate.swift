//
//  AppDelegate.swift
//  TableViewDynamicHeightCalculation
//
//  Created by Fani Hamdani on 31/10/19.
//  Copyright © 2019 fani. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.rootViewController = UINavigationController(rootViewController: MyViewController())
        window?.makeKeyAndVisible()
        
        return true
    }

}

