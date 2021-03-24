//
//  AppDelegate.swift
//  Home Guru
//
//  Created by Priya Vernekar on 19/10/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.


import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import CoreLocation
import Firebase
import MobileRTC
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // zoom keys
    let sdkKey = "kFopnlUmUv0AAt8BIYuVbxNEQIuyOmGQ6rKE"
    let sdkSecret = "VFh0b4T7udcEjTl5BE82tFBsFYwrQTBZvgnq"
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        isLoggedIn()
        window?.makeKeyAndVisible()
        GMSServices.provideAPIKey("AIzaSyBci_t4iFFKVhu1q8FXH_DneoFtHJxhjkQ")
        FirebaseApp.configure()
        //zoom integrate
        setupSDK(sdkKey: sdkKey, sdkSecret: sdkSecret)

        return true
    }
        /// setupSDK Creates, Initializes, and Authorizes an instance of the Zoom SDK. This must be called before calling any other SDK functions.
     
        /// - Parameters:
        ///   - sdkKey: A valid SDK Client Key provided by the Zoom Marketplace.
        ///   - sdkSecret: A valid SDK Client Secret provided by the Zoom Marketplace.
        func setupSDK(sdkKey: String, sdkSecret: String) {
            // Create a MobileRTCSDKInitContext. This class contains attributes for determining how the SDK will be used. You must supply the context with a domain.
            let context = MobileRTCSDKInitContext()
            // The domain we will use is zoom.us
            context.domain = "zoom.us"
            // Turns on SDK logging. This is optional.
            context.enableLog = true

            // Call initialize(_ context: MobileRTCSDKInitContext) to create an instance of the Zoom SDK. Without initialization, the SDK will not be operational. This call will return true if the SDK was initialized successfully.
            let sdkInitializedSuccessfully = MobileRTC.shared().initialize(context)

            // Check if initialization was successful. Obtain a MobileRTCAuthService, this is for supplying credentials to the SDK for authorization.
            if sdkInitializedSuccessfully == true, let authorizationService = MobileRTC.shared().getAuthService() {

     // Supply the SDK with SDK Key and SDK Secret.
    // To use a JWT instead, replace these lines with authorizationService.jwtToken = yourJWTToken.
                authorizationService.clientKey = sdkKey
                authorizationService.clientSecret = sdkSecret

                // Assign AppDelegate to be a MobileRTCAuthDelegate to listen for authorization callbacks.
                authorizationService.delegate = self

                // Call sdkAuth to perform authorization.
                authorizationService.sdkAuth()
            }
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






// MARK: - MobileRTCAuthDelegate
// Conform AppDelegate to MobileRTCAuthDelegate.
// MobileRTCAuthDelegate listens to authorization events like SDK authorization, user login, etc.
extension AppDelegate: MobileRTCAuthDelegate {
    func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {
//          switch returnValue {
//              case MobileRTCAuthError_Success:
//                  print("SDK successfully initialized.")
//              case MobileRTCAuthError_KeyOrSecretEmpty:
//                  assertionFailure("SDK Key/Secret was not provided. Replace sdkKey and sdkSecret at the top of this file with your SDK Key/Secret.")
//              case MobileRTCAuthError_KeyOrSecretWrong, MobileRTCAuthError_Unknown:
//                  assertionFailure("SDK Key/Secret is not valid.")
//              default:
//                  assertionFailure("SDK Authorization failed with MobileRTCAuthError: \(returnValue).")
//              }
    }
    

    // Result of calling sdkAuth(). MobileRTCAuthError_Success represents a successful authorization.

  }
