//
//  RechargeWalletViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 20/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit

class RechargeWalletViewController: BaseViewController {

    @IBOutlet weak var availablePointsLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func termsAndConditions(_ sender: UIButton) {
        // show terms and conditions
    }
    
    @IBAction func proceedAction(_ sender: UIButton) {
        // take to payment gateway
    }
    
}
