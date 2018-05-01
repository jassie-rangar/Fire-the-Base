//
//  AppDelegate.swift
//  Fire the base
//
//  Created by Jaskirat Singh on 15/04/18.
//  Copyright © 2018 jassie. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        window?.rootViewController = UINavigationController(rootViewController: UsersViewController())
        
        FirebaseApp.configure()
        
        return true
    }
    
}

