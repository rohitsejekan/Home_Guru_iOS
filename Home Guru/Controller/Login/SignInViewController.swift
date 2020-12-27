//
//  SignInViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 10/10/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire
import MBProgressHUD
import SKCountryPicker

class SignInViewController: BaseViewController {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var mobiletextField: UITextField!
    var userDetails : [String:Any] = ["password":"123456"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavbar()
        setupStatusBar()
        guard let country = CountryManager.shared.currentCountry else {
            return
        }
        customTextFieldPlaceholder(text: "Enter Phone Number", textField: mobiletextField)
        countryCodeLabel.text = country.dialingCode
    }
    
    @IBAction func countryCodePickerAction(_ sender: UIButton) {
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
            guard let self = self else { return }
            self.countryCodeLabel.text = country.dialingCode
            self.userDetails["mobileNo"] = self.countryCodeLabel.text! + self.mobiletextField.text!
        }
        countryController.detailColor = ColorPalette.textColor
    }
    
    @IBAction func SignInAction(_ sender: UIButton) {
        endEditing()
        if let mobileNo = userDetails["mobileNo"] as? String {
            if mobileNo.isEmpty {
                self.showAlert(title: "Message", message: "Please Enter Mobile Number")
                return
            }
        }
        
        let hud = MBProgressHUD()
        self.outerView.addSubview(hud)
        hud.show(animated: true)
        if !isNetConnectionAvailable() {
            hud.hide(animated: true)
            self.showAlert(title: "Message", message: "Please Check Your Internet Connection!")
            return
        }
        AlamofireService.alamofireService.postRequestWithBodyData(url: URLManager.sharedUrlManager.getParentAuth, details: userDetails) {
            response in
            switch response.result {
            case .success(let value):
                if let status =  response.response?.statusCode {
                    print("status is ..\(status)")
                    if status == 200 || status == 201 {
                        if let result = value as? [String:Any] {
                            print("result is ...\(result)")
                            if let token = result["token"] as? String, let parentDetails = result["parent"] as? [String:Any] {
                                if let mobileNo = parentDetails["mobileNo"] as? String {
                                    self.userDetails["mobileNo"] = mobileNo
                                }
                                UserDefaults.standard.set(true, forKey: Constants.isRegistered)
                                UserDefaults.standard.set(token, forKey: Constants.token)
                                UserDefaults.standard.set(parentDetails, forKey: Constants.parentDetails)
                                UserDefaults.standard.set(true,forKey: Constants.loginStatus)
                                UserDefaults.standard.set(false,forKey: Constants.loggedOut)
                                DispatchQueue.main.async {
                                    hud.hide(animated: true)
                                    let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "OTPVerificationViewController") as? OTPVerificationViewController
//                                    vc!.userDetails = self.userDetails
                                    self.navigationController?.pushViewController(vc!, animated: true)
                                }
                            }
                        }
                    }
                }
            case .failure( _):
                if let status =  response.response?.statusCode {
                    hud.hide(animated: true)
                    self.showAlert(title: "Message", message: (status == 400) ? "User with \(self.userDetails["mobileNo"] ?? "") isn't registered! Please Sign Up!" : Constants.serverDownMessage)
                    return
                }
            }
        }
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
        vc!.userDetails = self.userDetails
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

extension SignInViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let keyboardManager = IQKeyboardManager.shared
        if keyboardManager.canGoNext { keyboardManager.goNext(); } else  { view.endEditing(true) ; }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != nil {
            userDetails["mobileNo"] = (countryCodeLabel.text!) + textField.text!
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 10
    }
}
