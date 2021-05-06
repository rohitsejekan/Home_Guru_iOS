//
//  MyGuruDetailsViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 10/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import SwiftyJSON
import NVActivityIndicatorView
import JJFloatingActionButton
class MyGuruDetailsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    let actionButton = JJFloatingActionButton()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityLoaderView: NVActivityIndicatorView!
    var myGurusDetails : [String:Any] = [:]
    var slotDetails: [String: Any] = [:]
    var guruProfileDetails = [GetGuruProfile]()
      var guruProfileOnId = [GetGuruProfile]()
    var guruName: String = ""
    var guruId: String = ""
    var guruPic: String = ""
    var gu: String = "5"
    var Totalfare: Int = 0
    var guruFare: String = ""
    var guruPrice: String = ""
    override func viewDidLoad() {
        //floating button
        floatingButton()
        actionButton.buttonDiameter = 65
        actionButton.buttonImageSize = CGSize(width: 35, height: 35)
        //floating button ends
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "MyGuruCard", bundle: nil), forCellReuseIdentifier: "MyGuruCard")
        hideNavbar()
        getgurus()
       print("demo....\(StructOperation.glovalVariable.isDemo)")
        
    }
    func getgurus(){
        activityLoaderView.startAnimating()
            AlamofireService.alamofireService.getRequest(url: URLManager.sharedUrlManager.getGuruProfile + "\(guruId)", parameters: nil) {
                            response in
                               switch response.result {
                               case .success(let value):
                                   if let status =  response.response?.statusCode {
                                   print("guru p ..\(status)")
                                    print("g p...\(value)")
                                       if status == 200 || status == 201 {
                                    let val = JSON(value)
                                        for arr in val.arrayValue{
                                         self.guruProfileDetails.append(GetGuruProfile(json: arr))
                                           print("guru profile...\(self.guruProfileDetails)")
                    
                    
                                        }
                                           print("get guru p...\(self.guruProfileDetails)")
                                        for arr in self.guruProfileDetails{
                                            for arr1 in arr.guruSubjectDetails{
                                               if UserDefaults.standard.string(forKey: "classType") ?? "" == "1"{
                                                   self.guruFare = arr1.hourlyFees[0].facultyCharges
                                               }else{
                                                   self.guruFare = arr1.hourlyFees[1].facultyCharges
                                               }
                                                print("gurufare...\(self.guruFare)")
                                               // get the checked subjects . eg: ["maths","science"]
                                               if let checkName = UserDefaults.standard.object(forKey: "checkedName") as? [String]{
                                           // get faculty's selected subject
                                                   let results = arr1.guruPreferedSubject?.subjectName
                                               print("faculty subject.....\(results)")
                                               print("faculty checkname.....\(checkName)")
                                            // for loop to check user subject and faculty's subject match
                                                   for checkArr in  checkName{
                                                       if checkArr == results{
                                                        self.Totalfare = self.Totalfare + Int(self.guruFare)!
                                                                   print("checking subjects..\(arr1.hourlyFees[0].facultyCharges)")
                                                                       }else{
                                                                       print("no check")
                                                                   }
                                                       }
                                                  UserDefaults.standard.set(self.Totalfare, forKey: "totalFare")
                                                       print("total...\(self.Totalfare)")
                                                   
                                                                               
                                           }
        
                                            }
                                        }
                                        print("ok...\(self.guruProfileOnId)")
                                    DispatchQueue.main.async {
                                        self.activityLoaderView.stopAnimating()
                                        self.tableView.reloadData()
                                     }
                                                          }
                                   }
                               case .failure( _):
                                   print("failure")
                                        return
                                    }
                               }
    }
    @IBAction func closeAction(_ sender: UIButton) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playVideoAction(_ sender: UIButton) {
    }
    
    @IBAction func bookDemoClass(_ sender: UIButton) {
        let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "SelectSchedule") as! SelectScheduleViewController
                                      //setNavigationBackTitle(title: "Schedule")
         vc.hidesBottomBarWhenPushed = true
         vc.slotDetails = slotDetails
        vc.demoClass = true
        vc.reSchedule = false
        vc.guruFare = guruFare
        vc.guruProfile = guruPic
         vc.guruProfileDetails = guruProfileDetails
         self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func bookClassAction(_ sender: UIButton) {
        let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "SelectSchedule") as! SelectScheduleViewController
                                     //setNavigationBackTitle(title: "Schedule")
        vc.hidesBottomBarWhenPushed = true
        vc.slotDetails = slotDetails
        vc.demoClass = false
        vc.reSchedule = false
        vc.guruFare = guruFare
        vc.guruProfileDetails = guruProfileDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !guruProfileDetails.isEmpty{
            return guruProfileDetails[0].guruSubjectDetails.count + 2

        }else{
            return 3
        }
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !guruProfileDetails.isEmpty{
            switch indexPath.row {
             case 0:
                 let cell = tableView.dequeueReusableCell(withIdentifier: "MyGuruDetailsInfoCell", for: indexPath) as? MyGuruDetailsTableViewCell
                 cell?.guruNameLabel.text = guruProfileDetails[0].name
                 cell?.aboutDescriptionLabel.text = guruProfileDetails[0].aboutGuru
                 cell?.perClassAmountLabel.text = guruFare
                 cell?.guruImage.image = imageWithGradient(img: cell?.guruImage.image)
                 cell?.avatar.layer.cornerRadius = 40
                 if guruPic == ""{
                    cell?.avatar.image = UIImage(named: "facultyPlaceholder")
                 }else{
                    cell?.avatar.image = UIImage(named: "\(guruPic)")
                 }
                 
                 cell?.selectionStyle = .none
                 return cell!
             case 1:
                 let cell = tableView.dequeueReusableCell(withIdentifier: "MyGuruDetailsQualificationInfoCell", for: indexPath) as? MyGuruDetailsTableViewCell
                 cell?.selectionStyle = .none
                  cell?.qualificationLabel.text = guruProfileDetails[0].highQualification
                cell?.experienceLabel.text = guruProfileDetails[0].yearOfExperience + " years"
                 return cell!
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyGuruDetailsSubjectsInfoCell", for: indexPath) as? MyGuruDetailsTableViewCell
                    cell?.selectionStyle = .none
                    cell?.subjectPlaceholder.constant = 45
                
                // hide btn on demo value is 1
                if StructOperation.glovalVariable.isDemo == "1" {
                    cell?.demoBtn.isHidden = true
                }
                
                    cell?.subjectsLabel.text = guruProfileDetails[0].guruSubjectDetails[indexPath.row - 2].guruPreferedSubject?.subjectName
                return cell!
                case 3:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MyGuruDetailsSubjectsInfoCell", for: indexPath) as? MyGuruDetailsTableViewCell
                        cell?.selectionStyle = .none
                        cell?.subjectPlaceholder.constant = 0
                       
                        // hide btn on demo value is 1
                       if StructOperation.glovalVariable.isDemo == "1" {
                            cell?.demoBtn.isHidden = true
                        }
                        cell?.subjectsLabel.text = guruProfileDetails[0].guruSubjectDetails[indexPath.row - 2].guruPreferedSubject?.subjectName
                               return cell!
                
             default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyGuruDetailsSubjectsInfoCell", for: indexPath) as? MyGuruDetailsTableViewCell
                                                 cell?.selectionStyle = .none
                                                 cell?.subjectPlaceholder.constant = 0
                                                 cell?.subjectsLabel.text = guruProfileDetails[0].guruSubjectDetails[indexPath.row - 2].guruPreferedSubject?.subjectName
                                             return cell!
             }
        }else{
            return UITableViewCell()
        }
 
    }
    
    

}
extension MyGuruDetailsViewController{
    func floatingButton(){
              actionButton.addItem(title: "whatsApp", image: UIImage(named: "whatsApp")?.withRenderingMode(.alwaysTemplate)) { item in
              
                         
                         if let whatsappURL = URL(string: "https://api.whatsapp.com/send?phone=+919001990019&text=Invitation"), UIApplication.shared.canOpenURL(whatsappURL) {
                                        if #available(iOS 10, *) {
                                            UIApplication.shared.open(whatsappURL)
                                        } else {
                                            UIApplication.shared.openURL(whatsappURL)
                                        }
                         }
                     }

                     actionButton.addItem(title: "call", image: UIImage(named: "mdi_call")?.withRenderingMode(.alwaysTemplate)) { item in
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
