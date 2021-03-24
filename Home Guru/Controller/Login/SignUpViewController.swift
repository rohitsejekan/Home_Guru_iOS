//
//  SignUpViewController.swift
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
import FirebaseAuth
import Firebase
class SignUpViewController: BaseViewController {

    @IBOutlet weak var mobileNoTextField: UITextField!
    @IBOutlet weak var countryCodeLabel: UILabel!
    
    var userDetails : [String:Any] = ["password":"123456"]

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavbar()
        setupStatusBar()
        guard let country = CountryManager.shared.currentCountry else {
            return
        }
        customTextFieldPlaceholder(text: "Enter Phone Number", textField: mobileNoTextField)
        countryCodeLabel.text = country.dialingCode
    }

    @IBAction func signUpAction(_ sender: UIButton) {
       
        
  
        if let OtpFormateNumber = self.userDetails["mobileNo"]{
            print("your number ....\(OtpFormateNumber)")
            PhoneAuthProvider.provider().verifyPhoneNumber(OtpFormateNumber as! String, uiDelegate: nil) { (verificationID, error) in

                       if error != nil {

                           print("error:\(String(describing: error?.localizedDescription))")

                           print("1")

                           return

                       } else {

                           print("2")

                           UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                          
                         let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "OTPVerificationViewController") as? OTPVerificationViewController
                                vc!.userDetails = self.userDetails
                                self.present(vc!, animated: true, completion: nil)


                       }

                     

                   }
            
        }
       

            
    
    }
    
    @IBAction func signInAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func countryCodePickerAction(_ sender: UIButton) {
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
            guard let self = self else { return }
            self.countryCodeLabel.text = country.dialingCode
            self.userDetails["mobileNo"] = self.countryCodeLabel.text! + self.mobileNoTextField.text!
        }
        countryController.detailColor = ColorPalette.textColor
    }
}

extension SignUpViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 10
    }
    
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
}
