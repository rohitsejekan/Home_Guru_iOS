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
        let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "OTPVerificationViewController") as? OTPVerificationViewController
        vc!.userDetails = self.userDetails
        self.navigationController?.pushViewController(vc!, animated: true)
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
