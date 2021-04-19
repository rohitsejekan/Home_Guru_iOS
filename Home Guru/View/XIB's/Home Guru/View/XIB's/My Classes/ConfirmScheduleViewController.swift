//
//  ConfirmScheduleViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 15/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit
import SwiftyJSON
class ConfirmScheduleViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
   var guruProfileDetails = [GetGuruProfile]()
    var selectedDate: [String] = []
    var slotDetails: [String: Any] = [:]
    var confirmBook: [String: Any] = [:]
    var getTimeSlot: [String] = []
    var userSubId: [String] = []
    var classTypeId: String = ""
    var guruId: String = ""
    var guruFare: String = ""
    var totalFare: String = ""
    var subjectDatesSlot: [[String: String]] = [[:]]
    var getSubjectSlots: [[String: Any]] = [[:]]
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        tableView.estimatedRowHeight = 142.0
        tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
        // custom button
         tableView.register(UINib(nibName: "customButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "customButton")
        
       print("added subject...\(slotDetails)")
       guruFare = UserDefaults.standard.string(forKey: "guruFare") ?? ""
       totalFare = UserDefaults.standard.string(forKey: "totalFare") ?? ""
        //
                 
        print("total fare.....\(totalFare)")
        confirmBooking()
    }
    
    func confirmBooking(){
        slotDetails = UserDefaults.standard.value(forKey: "dict") as! [String: Any]
        userSubId = UserDefaults.standard.object(forKey: "subjectId") as! [String]
        classTypeId = UserDefaults.standard.string(forKey: "classType") ?? ""
        guruId = UserDefaults.standard.string(forKey: "guruId") ?? ""
        if let subArray = slotDetails["subject"] as? [[String:Any]] {
                   getSubjectSlots = subArray
                for timeSlot in getSubjectSlots{
                    self.getTimeSlot.append(timeSlot["start"] as? String ?? "")
                    
                }
                     print("got subjectt...\(getTimeSlot)")
               }
               confirmBook["subject"] = userSubId
               confirmBook["timeSlotFrom"] = getTimeSlot
               confirmBook["classType"] = classTypeId
               confirmBook["is_demo"] = 0
               confirmBook["facultyId"] = guruId
        confirmBook["studentId"] = StructOperation.glovalVariable.studentId
               confirmBook["noOfHours"] = 2
               confirmBook["hourlyCompensation"] = guruFare
        confirmBook["classes"] = StructOperation.glovalVariable.subjectDatesSlot
        
               print("confirm book...\(confirmBook)")
               
           //        parentDetails["mobileNo"] = UserDefaults.standard.string(forKey: Constants.mobileNo)
                   AlamofireService.alamofireService.postRequestWithBodyData(url: URLManager.sharedUrlManager.makeBooking, details: confirmBook) {
                   response in
                      switch response.result {
                      case .success(let value):
                          if let status =  response.response?.statusCode {
                          print("status issw ..\(status)")
                           print("value...\(value)")
                              if status == 200 || status == 201 {
                           let val = JSON(value)
                               for arr in val.arrayValue{
                              //  self.getSubjects.append(GetSubjects(json: arr))
                                   print("child sub...\(arr)")
                                
                                   
                               }
                                //print("get sub...\(self.getSubjects)")
                                                     
                           DispatchQueue.main.async {
                          
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSubjectSlots.count + 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "confirmSheduleFirst", for: indexPath) as!
            confirmSheduleFirstTableViewCell
            cell.guruName.text = guruProfileDetails[0].name
            cell.GuruSkills.text = guruProfileDetails[0].languagesKnown
            cell.GuruFare.text = guruFare
            cell.configure(with: self.selectedDate)
//            DispatchQueue.main.async {
//                cell.selectedDate1 = self.selectedDate
//                cell.datesCV.reloadData()
//                cell.getLoad()
//            }
              return cell
        }else if indexPath.row <= getSubjectSlots.count{
            if getSubjectSlots.count > 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmScheduleSecond", for: indexPath) as! ConfirmScheduleSecondTableViewCell
                cell.subjectName.text = getSubjectSlots[indexPath.row - 1]["name"] as? String
                cell.subjectTime.text =  getSubjectSlots[indexPath.row - 1]["start"] as? String
                        return cell
            }else{
                return UITableViewCell()
            }
            
        }else if indexPath.row == getSubjectSlots.count + 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "confirmScheduleThird", for: indexPath) as! confirmScheduleThirdTableViewCell
            cell.totalAmount.text = totalFare
            cell.noOfClass.text = String(getSubjectSlots.count)
                               return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "customButton", for: indexPath) as! customButtonTableViewCell
            cell.goToDelegate = self
            return cell
        }
  
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == getSubjectSlots.count + 2{
            return 90
        }else{
            return UITableView.automaticDimension
        }
        
    }

}
extension ConfirmScheduleViewController: nextScreen{
    func gotoScreen() {
   self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
}
