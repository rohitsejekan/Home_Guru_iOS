//
//  OTPVerificationViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 10/10/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import SVPinView
import IQKeyboardManagerSwift
import MBProgressHUD
//import FirebaseAuth

class OTPVerificationViewController: BaseViewController {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var otpView: SVPinView!
    @IBOutlet weak var msgLabel: UILabel!
    
    var userDetails : [String:Any] = ["password":"123456"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.endEditing(true)
        hideNavbar()
        if let mobileNo = userDetails["mobileNo"] as? String {
            msgLabel.text = "Please type the verification code sent to \(mobileNo)"
        }
        configurePinView()
        sendOTP()
    }
    
    @IBAction func verifyOTPAction(_ sender: UIButton) {
        endEditing()
        //        verifyOTP()
        print("Logged in user")
        UserDefaults.standard.set(true, forKey: Constants.loginStatus)
        DispatchQueue.main.async {
            // direct login if logged in
//            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//            appDelegate.isLoggedIn()
            let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "myRegisterVC") as! myRegisterViewController
            vc.hidesBottomBarWhenPushed = true
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func resendOTPAction(_ sender: UIButton) {
        sendOTP()
    }
    
    func sendOTP() {
        var phoneNumber = ""
        if let phoneNo = userDetails["mobileNo"] as? String {
            phoneNumber = phoneNo
        }
        print("phoneNo is ...\(phoneNumber)")
//        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
//            if let error = error {
//                print("Error is... \(error)")
//                self.showAlert(title: "Message", message: "Couldn't send OTP! Please try again!!")
//                return
//            }
//            // Sign in using the verificationID and the code sent to the user
//            // ...
//            print("OTP Sent")
//            self.showAlert(title: "Message", message: "OTP sent Successfully!!")
//            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
//        }
    }
    
    
    func verifyOTP(){
//        let hud = MBProgressHUD()
//        self.outerView.addSubview(hud)
//        hud.show(animated: true)
//        print("data is ..\(userDetails)")
//        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
//        let credential = PhoneAuthProvider.provider().credential(
//            withVerificationID: verificationID ?? "",
//            verificationCode: self.userDetails["otp"] as! String ?? "")
//        print("credential ..\(credential)")
//        Auth.auth().signIn(with: credential) { (authResult, error) in
//            if let error = error {
//                self.showAlert(title: "Message!", message: "Invalid OTP!")
//                print("error is ..\(error)")
//                hud.hide(animated: true)
//                return
//            }
//            // User is signed in
//            // ...
//            hud.hide(animated: true)
//            print("Logged in user")
            UserDefaults.standard.set(true, forKey: Constants.loginStatus)
            UserDefaults.standard.set(true, forKey: Constants.isRegistered)
            DispatchQueue.main.async {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                appDelegate.isLoggedIn()
            }
//        }
    }
    
    func configurePinView() {
        otpView.pinLength = 6
        otpView.secureCharacter = "\u{25CF}"
        otpView.interSpace = 5
        otpView.activeBorderLineColor = UIColor.black
        otpView.borderLineThickness = 1
        otpView.shouldSecureText = true
        otpView.allowsWhitespaces = false
        otpView.activeBorderLineThickness = 4
        otpView.fieldBackgroundColor = UIColor.clear
        otpView.activeFieldBackgroundColor = UIColor.clear
        otpView.fieldCornerRadius = 0
        otpView.activeFieldCornerRadius = 0
        otpView.style = .underline
        otpView.placeholder = "******"
        //        otpView.becomeFirstResponderAtIndex = 0
        
        otpView.font = UIFont.systemFont(ofSize: 15)
        otpView.keyboardType = .phonePad
        otpView.pinInputAccessoryView = { () -> UIView in
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            doneToolbar.barStyle = UIBarStyle.default
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
            
            var items = [UIBarButtonItem]()
            items.append(flexSpace)
            items.append(done)
            
            doneToolbar.items = items
            doneToolbar.sizeToFit()
            return doneToolbar
        }()
        
        otpView.didFinishCallback = didFinishEnteringPin(pin:)
        otpView.didChangeCallback = { pin in
            print("The entered pin is \(pin)")
        }
    }
    
    func didFinishEnteringPin(pin:String) {
        userDetails["otp"] = pin
    }
    
}
