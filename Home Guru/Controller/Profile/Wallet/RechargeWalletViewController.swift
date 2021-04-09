//
//  RechargeWalletViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 20/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import Razorpay
class RechargeWalletViewController: BaseViewController,RazorpayPaymentCompletionProtocol, UITextFieldDelegate {

    @IBOutlet weak var availablePointsLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    var amount: Int = 0
     var razorpay: RazorpayCheckout!
    override func viewDidLoad() {
        super.viewDidLoad()
             razorpay = RazorpayCheckout.initWithKey("rzp_test_TLpg89CUg8B1bI", andDelegate: self)
    }
        func onPaymentError(_ code: Int32, description str: String) {
    //        let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "PaymentStatusViewController") as? PaymentStatusViewController
    //                       vc!.status = .failure
    //        self.navigationController?.pushViewController(vc!, animated: true)
            let alert = UIAlertController(title: "Error", message: "\(code)\n\(str)", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        func onPaymentSuccess(_ payment_id: String) {
            print("payment_id is ..\(payment_id)")
            saveTransactionDetails(paymentId: payment_id)
            let alert = UIAlertController(title: "SUCCESS!", message: "Payment is successful", preferredStyle: .alert)
                   let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                   alert.addAction(action)
                   self.present(alert, animated: true, completion: nil)
        }
    func textFieldDidEndEditing(_ textField: UITextField) {
        amount = Int(amountTextField.text!) ?? 0

        print("amount.....\(amount)")
    }
    func saveTransactionDetails(paymentId: String) {
        var details : [String:Any] = [
            "transactionType": "credit",
            "amount": "\(amountTextField.text)",
            "paymentRef": paymentId,
            "status": true
        ]
       
        AlamofireService.alamofireService.postRequestWithBodyDataAndToken(url: URLManager.sharedUrlManager.createTransactionRecord, details: details) {
            response in
            switch response.result {
            case .success(let value):
                if let status =  response.response?.statusCode {
                    print("status is ..\(status)")
                    if status == 200 || status == 201 {
                        if let result = value as? [String:Any] {
                            print("result is ...\(result)")
                           // self.getCurrentPoints()
                        }
                        DispatchQueue.main.async {
                         //   let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "PaymentStatusViewController") as? PaymentStatusViewController
                          //  vc!.status = .success
                           // self.navigationController?.pushViewController(vc!, animated: true)
                        }
                    } else {
                        self.showAlert(title: Constants.unknownTitle, message: Constants.unknownMsg)
                    }
                }
            case .failure( _):
                self.showAlert(title: Constants.unknownTitle, message: Constants.unknownMsg)
            }
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func termsAndConditions(_ sender: UIButton) {
        // show terms and conditions
    }
    
    @IBAction func proceedAction(_ sender: UIButton) {
        
        // take to payment gateway
        let options:[String:Any] = ["amount" : "\(amount))",
                                      "description" : "for test purpose",
                                      "image": UIImage(named: "img"),
                                      "name" : "business name",
                                      "prefill" :
                                          ["contact" : "9876543210",
                                           "email":"demo@inm.com"],
                                      "theme" : "#F00000"]
          razorpay?.open(options)
    }
    
}
