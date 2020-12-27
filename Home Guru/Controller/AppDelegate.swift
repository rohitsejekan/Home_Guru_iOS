//
//  AppDelegate.swift
//  Home Guru
//
//  Created by Priya Vernekar on 19/10/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        isLoggedIn()
        window?.makeKeyAndVisible()
        return true
    }
    
    func isLoggedIn() {
        if !UserDefaults.standard.bool(forKey: Constants.loginStatus) {
            showLogin()
        } else {
            setLoggedInRoot()
        }
    }
    
    func showLogin() {
        let rootVC = Constants.mainStoryboard.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController
        UserDefaults.standard.set(false,forKey: Constants.loggedOut)
        self.window?.rootViewController = UINavigationController(rootViewController: rootVC!)
    }
    
    func setLoggedInRoot() {
        let rootVc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let nav = UINavigationController(rootViewController: rootVc)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}






