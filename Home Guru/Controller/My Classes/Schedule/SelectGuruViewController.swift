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
class SelectGuruViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var backBtn: UIButton!
    var guruDetails : [String:Any] = [:]
    var slotDetails: [String: Any] = [:]
    var gu: String = "5"
    var guruProfileDetails = [GetGuruProfile]()
    var guruProfileOnId = [GetGuruProfile]()
    var getGuruDetails = [getGurusubject]()
    var guruFare: [String] = []
  
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
        getGuru()
        
        print("slot d...\(slotDetails)")
   
    }
    
    
    
    func getGuru(){
        
        guruDetails["subject"] = [1,2]
        guruDetails["hours"] = [1,1]
        guruDetails["time"] = ["10:00", "11:00"]
        
       // print("...\(UserDefaults.standard.string(forKey: "groupId"))")
        if let classType = UserDefaults.standard.string(forKey: "classType"){
            print("classType...\(classType)")
            guruDetails["classType"] = classType

        }
        if let groupId = UserDefaults.standard.string(forKey: "groupId"){
            print("groupId...\(groupId)")
            guruDetails["groupId"] = "7"

        }
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
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
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
        return getGuruDetails.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "SelectGuru", for: indexPath) as? SelectGuruTableViewCell
               
                  cell?.selectionStyle = .none
                  cell?.preservesSuperviewLayoutMargins = false
                        cell?.separatorInset = .zero
                        cell?.layoutMargins = .zero
        cell?.guruName.text = getGuruDetails[indexPath.row].name
        cell?.languageKnown.text = getGuruDetails[indexPath.row].languages
        cell?.guruFare.text = "Rs "+guruFare[indexPath.row] + "/hour"
          //        cell?.radioImageView.image = UIImage(named: indexPath.row == index ? "radioSelected" : "radioUnselected")
                
                  return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
               let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "MyGuruDetailsViewController") as! MyGuruDetailsViewController
                               //setNavigationBackTitle(title: "Schedule")
                               vc.hidesBottomBarWhenPushed = true
        vc.guruId = getGuruDetails[indexPath.row]._id
         UserDefaults.standard.set(getGuruDetails[indexPath.row]._id, forKey: "guruId")
        UserDefaults.standard.set(guruFare, forKey: "guruFare")
        print("1..\(slotDetails)")
        vc.slotDetails = slotDetails
       
                self.navigationController?.pushViewController(vc, animated: false)

        
    }

}
