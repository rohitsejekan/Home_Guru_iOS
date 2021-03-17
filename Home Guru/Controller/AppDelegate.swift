//
//  AppDelegate.swift
//  Home Guru
//
//  Created by Priya Vernekar on 19/10/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import CoreLocation
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        isLoggedIn()
        window?.makeKeyAndVisible()
        GMSServices.provideAPIKey("AIzaSyBci_t4iFFKVhu1q8FXH_DneoFtHJxhjkQ")

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
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController
        UserDefaults.standard.set(false,forKey: Constants.loggedOut)
        self.window?.rootViewController = rootVC
    }
    
    func setLoggedInRoot() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootVc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        // not to done as below
//        let nav = UINavigationController(rootViewController: rootVc)
//        window?.rootViewController = nav
        window?.rootViewController = rootVc
        window?.makeKeyAndVisible()
    }
}






