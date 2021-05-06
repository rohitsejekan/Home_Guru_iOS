//
//  AccountViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 20/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class AccountViewController: UIViewController {

    @IBOutlet weak var activityLoaderView: NVActivityIndicatorView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var landMarkLabel: UILabel!
    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var stateName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var pinCodeLabel: UILabel!
    @IBOutlet weak var outerBox: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        outerBox.layer.cornerRadius = 15.0
        // Do any additional setup after loading the view.
        // back button
        backBtn.layer.cornerRadius = 5
        //user address
        let a = UserDefaults.standard.string(forKey: "g_address")
        print("a..\(a)")
        getActiveUser()
    }
    func getActiveUser(){
        activityLoaderView.startAnimating()
        AlamofireService.alamofireService.getRequestWithToken(url: URLManager.sharedUrlManager.activeUser, parameters: nil) { response
                     in
                     switch response.result {
                     case .success(let value):
                         if let status =  response.response?.statusCode {
                             print("svis ..\(value)")
                             print("sstatus is ..\(status)")
                             if status == 200 || status == 201 {
                                 let json = JSON(value)
                                self.phoneLabel.text = json["mobileNo"].stringValue
                                self.userName.text = json["name"].stringValue
                                // store parent email and phone
                                StructOperation.glovalVariable.parentPhone = json["mobileNo"].stringValue
                                StructOperation.glovalVariable.parentEmail = json["email"].stringValue
                                // store parent email and phone
                                self.emailLabel.text = json["email"].stringValue
                                for arr in json["residentalAddress"].arrayValue{
                                    self.pinCodeLabel.text = "Pin Code: " + arr["pincode"].stringValue
                                    self.cityName.text = "City: " + arr["city"].stringValue
                                    self.stateName.text = "State: " + arr["state"].stringValue
                                    self.landMarkLabel.text = "LandMark: " + arr["landmark"].stringValue
                                    self.addressLabel.text = StructOperation.glovalVariable.address
                                    
                                }

                                 DispatchQueue.main.async {
                                     self.activityLoaderView.stopAnimating()

                                 }
                             }
                         }
                     case .failure( _):
                         print("failure")
                     }
                 }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
