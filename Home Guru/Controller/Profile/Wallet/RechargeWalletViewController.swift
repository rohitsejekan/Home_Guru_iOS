//
//  RechargeWalletViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 20/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import Razorpay
import SwiftyJSON
class RechargeWalletViewController: BaseViewController,RazorpayPaymentCompletionProtocol, UITextFieldDelegate {

    @IBOutlet weak var availablePointsLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    var amount: Int?
     var razorpay: RazorpayCheckout!
    var paymentSuccess: [String: String] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
             razorpay = RazorpayCheckout.initWithKey("rzp_test_TLpg89CUg8B1bI", andDelegate: self)
//        razorpay = RazorpayCheckout.initWithKey("rzp_live_NBgNfxcb6H93HM", andDelegate: self)
        
        amountTextField.delegate = self
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
//            saveTransactionDetails(paymentId: payment_id)
//            let alert = UIAlertController(title: "SUCCESS!", message: "Payment is successful", preferredStyle: .alert)
//                   let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//                   alert.addAction(action)
//                   self.present(alert, animated: true, completion: nil)
            paymentSuccess["amount"] = "\(amountTextField.text!)"
                   paymentSuccess["paymentRef"] = payment_id
                   print("confirm book...\(paymentSuccess)")
                   
               //        parentDetails["mobileNo"] = UserDefaults.standard.string(forKey: Constants.mobileNo)
                       AlamofireService.alamofireService.postRequestWithBodyDataAndToken(url: URLManager.sharedUrlManager.wallet, details: paymentSuccess) {
                       response in
                          switch response.result {
                          case .success(let value):
                              if let status =  response.response?.statusCode {
                              print("status issw ..\(status)")
                               print("value...\(value)")
                                  if status == 200 || status == 201 {
                               let val = JSON(value)
                                 
                                print("val...\(val)")
                                                         
                               DispatchQueue.main.async {
                              
                                }
                                                     }
                              }
                          case .failure( _):
                              print("failure")
                                   return
                               }
                          }
        }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let amt = Int(amountTextField.text ?? "1"){
            amount = amt * 100
        }

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
        let options:[String:Any] = ["amount" : amount ?? 1,
                                      "description" : "for test purpose",
                                      "image": UIImage(named: "img"),
                                      "name" : "business name",
                                      "prefill" :
                                          ["contact" : "9845876654",
                                           "email":"demo@inm.com"],
                                      "theme" : "#F00000"]
          razorpay?.open(options)
    }
    
}

