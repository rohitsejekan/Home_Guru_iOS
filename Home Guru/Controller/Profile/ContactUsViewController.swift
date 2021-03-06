//
//  ContactUsViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 20/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import MBProgressHUD
import NVActivityIndicatorView

class ContactUsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    var details  : [String:String] = ["feedback":"","query":""]
    
    @IBOutlet weak var activityLoaderView: NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavbar()
        tableView.estimatedRowHeight = 260.0
        tableView.rowHeight = UITableView.automaticDimension
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
    }
        
//    @IBAction func callAction(_ sender: UIButton) {
//        if let url = URL(string: "tel://\(Constants.contactUs)"), UIApplication.shared.canOpenURL(url) {
//            if #available(iOS 10, *) {
//                UIApplication.shared.open(url)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
//        }
//    }
    @IBAction func makeCall(_ sender: UIButton) {
        if let url = URL(string: "tel://\(Constants.contactUs)"), UIApplication.shared.canOpenURL(url) {
                  if #available(iOS 10, *) {
                      UIApplication.shared.open(url)
                  } else {
                      UIApplication.shared.openURL(url)
                  }
              }
    }
    
//    @IBAction func sendMessageAction(_ sender: UIButton) {
//        view.endEditing(true)
//        print("clicked")
//        if sender.tag == 2 {
//            if details["feedback"]!.isEmpty {
//                self.showAlert(title: "Message", message: "Please Write the Feedback to Proceed!")
//                return
//            }
//        } else  {
//            if details["query"]!.isEmpty {
//                self.showAlert(title: "Message", message: "Please Write the Query to Proceed!")
//                return
//            }
//            contactUs()
//        }
//    }
    
    @IBAction func sendQuery(_ sender: UIButton) {
        print("clicked")
              if sender.tag == 2 {
                  if details["feedback"]!.isEmpty {
                      self.showAlert(title: "Message", message: "Please Write the Feedback to Proceed!")
                      return
                  }
              } else  {
                  if details["query"]!.isEmpty {
                      self.showAlert(title: "Message", message: "Please Write the Query to Proceed!")
                      return
                  }
                  contactUs()
              }
    }
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactUsTableViewCell", for: indexPath) as? ContactUsTableViewCell
            cell?.contactImage.image = imageWithGradient(img: cell?.contactImage.image)
            cell?.selectionStyle = .none
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackContactUsCell", for: indexPath) as? ContactUsTableViewCell
            cell?.messageLabel.text = "Please write a query and expect a reply within 24 hours"
            cell?.titleLabel.text = "Message Us"
            cell?.inputTextField.tag = indexPath.row
            cell?.inputTextField.delegate = self
           //cell?.sendMessageBtn.tag = indexPath.row
            cell?.selectionStyle = .none
            return cell!
        }
    }
    
    func showAlertWithHandler(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert,animated: true,completion: nil)
    }
    
    func contactUs() {
        let data : [String:String] = ["query":details["query"] ?? "","deviceType":"ios"]
        let hud = MBProgressHUD()
        self.tableView.addSubview(hud)
        hud.show(animated: true)
        if !isNetConnectionAvailable() {
            self.hideLoader(loader: hud)
            self.showAlert(title: "Message", message: "Please Check Your Internet Connection!")
            return
        }
        activityLoaderView.startAnimating()
                //        parentDetails["mobileNo"] = UserDefaults.standard.string(forKey: Constants.mobileNo)
                //  print("cancel body....\(cancelClass)")
                        AlamofireService.alamofireService.postRequestWithBodyDataAndToken(url: URLManager.sharedUrlManager.contactus, details:data) {
                            response in
                            switch response.result {
                                case .success(let value):
                                if let status =  response.response?.statusCode {
                                        print("status issw ..\(status)")
                                        print("value...\(value)")
                                        if status == 200 || status == 201 {
                                            
                                                
                                        //print("get sub...\(self.getSubjects)")
                                         DispatchQueue.main.async {
                                            self.activityLoaderView.stopAnimating()
                                          hud.hide(animated: true)
                                          self.showAlertWithHandler(title: "Message", message: "Successfully Submited Query!")
                                                               }
                                                                         }
                                                  }
                            case .failure( _):
                              hud.hide(animated: true)
                              self.showAlert(title: Constants.unknownTitle, message: Constants.unknownMsg)
                                                   }
                                              }
   
    }
    

    
}
extension ContactUsViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        details["query"] = textField.text
        print("text..\(details["query"])")
    }
}
