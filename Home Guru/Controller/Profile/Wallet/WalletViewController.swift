//
//  WalletViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 20/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit

class WalletViewController: BaseViewController {

    @IBOutlet weak var availablePointsLabel: UILabel!
    @IBOutlet weak var settingsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavbar()
        hideUnhideView(view: settingsView, status: true)
    }
    
    @IBAction func referAndEarnAction(_ sender: UIButton) {
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rechargeAction(_ sender: UIButton) {
        let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "RechargeWalletViewController") as? RechargeWalletViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func settingsAction(_ sender: UIButton) {
        hideUnhideView(view: settingsView, status: false)
    }
    
    @IBAction func paymentHistoryAction(_ sender: UIButton) {
        hideUnhideView(view: settingsView, status: true)
        let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "PaymentHistoryViewController") as? PaymentHistoryViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func priceDetailsAction(_ sender: UIButton) {
        hideUnhideView(view: settingsView, status: true)
        // show price details screen
    }
    

}
