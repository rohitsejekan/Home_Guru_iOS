//
//  SelectGuruViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 13/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import JJFloatingActionButton
class SelectGuruViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let actionButton = JJFloatingActionButton()
    @IBOutlet weak var activityLoaderView: NVActivityIndicatorView!
    @IBOutlet weak var backBtn: UIButton!
    var guruDetails : [String:Any] = [:]
    var slotDetails: [String: Any] = [:]
    var gu: String = "5"
    var guruProfileDetails = [GetGuruProfile]()
    var guruProfileOnId = [GetGuruProfile]()
    var getGuruDetails = [getGurusubject]()
    var guruFare: [String] = []
    var selectedSlot: [String] = []
    var selectedDuration: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //floating button
        floatingButton()
        actionButton.buttonDiameter = 65
        actionButton.buttonImageSize = CGSize(width: 35, height: 35)
        //floating button ends
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        backBtn.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
        getGuru()
        
        print("slot d...\(slotDetails)")
        
        // custom userupdate cell
        tableView.register(UINib(nibName: "userUpdateTableViewCell", bundle: nil), forCellReuseIdentifier: "userUpdate")
    }
    
    
    
    func getGuru(){
        activityLoaderView.startAnimating()
        guruDetails["subject"] = UserDefaults.standard.object(forKey: "subjectId") as! [String]
        guruDetails["hours"] = selectedDuration
        guruDetails["time"] = selectedSlot
        
        // print("...\(UserDefaults.standard.string(forKey: "groupId"))")
        if let classType = UserDefaults.standard.string(forKey: "classType"){
            print("classType...\(classType)")
            guruDetails["classType"] = classType
            
        }
        if let groupId = UserDefaults.standard.string(forKey: "groupId"){
            print("groupId...\(groupId)")
            guruDetails["groupId"] = "7"
             //guruDetails["groupId"] = groupId
            
        }
        print("getGuruSubject body...\(guruDetails)")
        AlamofireService.alamofireService.postRequestWithBodyData(url: URLManager.sharedUrlManager.getGuruSubject, details: guruDetails) {
            response in
            switch response.result {
            case .success(let value):
                if let status =  response.response?.statusCode {
                    print("status is ..\(status)")
                    print("value...\(value)")
                    if status == 200 || status == 201 {
                        let json = JSON(value)
                        for arr in json.arrayValue{
                            print("get guru....\(arr)")
                            self.getGuruDetails.append(getGurusubject(json: arr))
                        }
                        print("...getguruDetails..\(self.getGuruDetails)")
                        
                    }
                    
                    // to get faculty fare based on classtype
                    for arr in self.getGuruDetails{
                        for arr1 in arr.guruSubjectDetail{
                            if UserDefaults.standard.string(forKey: "classType") ?? "" == "1"{
                                self.guruFare.append(arr1.hourlyFees[0].facultyCharges)
                                print("guru fare..\(self.guruFare)")
                            }else{
                                
                                self.guruFare.append(arr1.hourlyFees[1].facultyCharges)
                                
                                print("guru fare..\(self.guruFare)")
                            }
                            
                        }
                        
                    }
                    DispatchQueue.main.async {
                        self.activityLoaderView.stopAnimating()
                        self.tableView.reloadData()
                    }
                }
            case .failure( _): break
                
            }
        }
    }
    @IBAction func goBack(_ sender: Any) {
        // self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if getGuruDetails.isEmpty{
            return 1
        }else{
            return getGuruDetails.count
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !getGuruDetails.isEmpty{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectGuru", for: indexPath) as! SelectGuruTableViewCell
            
            cell.selectionStyle = .none
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = .zero
            cell.layoutMargins = .zero
            cell.guruName.text = getGuruDetails[indexPath.row].name
            cell.languageKnown.text = getGuruDetails[indexPath.row].languages
            cell.facultyAvatar.layer.cornerRadius = cell.facultyAvatar.frame.width/2
            cell.facultyAvatar.clipsToBounds = true
            if getGuruDetails[indexPath.row].profilePic?.profile != ""{
                if let img = getGuruDetails[indexPath.row].profilePic?.profile{
                    let url = URL(string: img)
                    cell.facultyAvatar.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
                    cell.facultyAvatar.kf.indicatorType = .activity
                }
            }else{
                cell.facultyAvatar.image = UIImage(named: "facultyPlaceholder")
            }
            
            if !guruFare.isEmpty{
                cell.guruFare.text = "Rs "+guruFare[indexPath.row] + "/hour"
                
            }else{
                cell.guruFare.text = ""
            }
            //        cell?.radioImageView.image = UIImage(named: indexPath.row == index ? "radioSelected" : "radioUnselected")
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "userUpdate", for: indexPath) as! userUpdateTableViewCell
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "MyGuruDetailsViewController") as! MyGuruDetailsViewController
        //setNavigationBackTitle(title: "Schedule")
        vc.hidesBottomBarWhenPushed = true
        vc.guruId = getGuruDetails[indexPath.row]._id
        vc.guruPic = getGuruDetails[indexPath.row].profilePic?.profile ?? ""
        UserDefaults.standard.set(getGuruDetails[indexPath.row]._id, forKey: "guruId")
        UserDefaults.standard.set(guruFare, forKey: "guruFare")
        print("1..\(slotDetails)")
        vc.slotDetails = slotDetails
        
        self.navigationController?.pushViewController(vc, animated: false)
        
        
    }
    
}
extension SelectGuruViewController{
    func floatingButton(){
              actionButton.addItem(title: "", image: UIImage(named: "whatsApp")?.withRenderingMode(.alwaysTemplate)) { item in
              
                         
                         if let whatsappURL = URL(string: "https://api.whatsapp.com/send?phone=+919001990019&text=Invitation"), UIApplication.shared.canOpenURL(whatsappURL) {
                                        if #available(iOS 10, *) {
                                            UIApplication.shared.open(whatsappURL)
                                        } else {
                                            UIApplication.shared.openURL(whatsappURL)
                                        }
                         }
                     }

                     actionButton.addItem(title: "", image: UIImage(named: "mdi_call")?.withRenderingMode(.alwaysTemplate)) { item in
                       // do something
                   if let url = URL(string: "tel://\(Constants.contactUs)"), UIApplication.shared.canOpenURL(url) {
                                      if #available(iOS 10, *) {
                                          UIApplication.shared.open(url)
                                      } else {
                                          UIApplication.shared.openURL(url)
                                      }
                                  }
                     }

                     actionButton.buttonImage = UIImage(named: "customer-service")
                     actionButton.buttonColor = ColorPalette.homeGuruDarkGreyColor
                     view.addSubview(actionButton)
                     actionButton.translatesAutoresizingMaskIntoConstraints = false
                     if #available(iOS 11.0, *) {
                         actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
                     } else {
                         // Fallback on earlier versions
                         actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
                     }
                     if #available(iOS 11.0, *) {
                         actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
                     } else {
                         // Fallback on earlier versions
                         actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
                     }
          }
          
}
