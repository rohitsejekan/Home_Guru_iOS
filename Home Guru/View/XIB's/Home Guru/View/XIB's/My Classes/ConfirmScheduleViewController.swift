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
    var slotDetails = [String: Any]()
    var confirmBook: [String: Any] = [:]
    var getTimeSlot: [String] = []
    var userSubId: [String] = []
    var classTypeId: String = ""
    var guruId: String = ""
    var guruFare: String = ""
    var totalFare: String = ""
    var bookDemo: Bool?
    var reschedle: Bool?
    var subjectDatesSlot: [[String: String]] = [[:]]
    @IBOutlet weak var backBtn: UIButton!
    var getSubjectSlots: [[String: Any]] = [[:]]
    var selectedTimeSlot: String = ""
    var currentMonth: String = ""
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //back btn
        backBtn.layer.cornerRadius = 7
        
        // print("guru...\(guruProfileDetails[0].name)")
        tableView.estimatedRowHeight = 142.0
        tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
        // custom button
        tableView.register(UINib(nibName: "customButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "customButton")
        
        print("added subject...\(slotDetails)")
        if let subArray = slotDetails["subject"] as? [[String:Any]] {
            getSubjectSlots = subArray
            print("got subject...\(getSubjectSlots)")
        }
        
        //   guruFare = UserDefaults.standard.string(forKey: "guruFare") ?? ""
        totalFare = UserDefaults.standard.string(forKey: "totalFare") ?? ""
        //
        print("reschedule...\(reschedle)")
        print("is demo....\(StructOperation.glovalVariable.isDemo)")
        print("stu id...\(StructOperation.glovalVariable.studentId)")
        print("points......\(StructOperation.glovalVariable.points)")
        //reSchedule()
        // check demo
        print("demo......\(bookDemo)")
        print("classes......\(StructOperation.glovalVariable.subjectDatesSlot)")
    }
    func reSchedule(){
        
        classTypeId = UserDefaults.standard.string(forKey: "classType") ?? ""
        guruId = UserDefaults.standard.string(forKey: "guruId") ?? ""
        
        confirmBook["timeSlotFrom"] = StructOperation.glovalVariable.reScheduleTimeSlotFrom
        confirmBook["classType"] = classTypeId
        confirmBook["is_demo"] = StructOperation.glovalVariable.isDemo
        confirmBook["facultyId"] = guruId
        confirmBook["studentId"] = "2"
        //                confirmBook["studentId"] = StructOperation.glovalVariable.studentId
        confirmBook["noOfHours"] = StructOperation.glovalVariable.timeDifference
        //               confirmBook["hourlyCompensation"] = guruFare
        confirmBook["hourlyCompensation"] = UserDefaults.standard.string(forKey: "totalFare")
        confirmBook["date"] = selectedTimeSlot
        confirmBook["classId"] = StructOperation.glovalVariable.classId
        
        print("confirm reschedule book...\(confirmBook)")
        
        //        parentDetails["mobileNo"] = UserDefaults.standard.string(forKey: Constants.mobileNo)
        AlamofireService.alamofireService.postRequestWithBodyDataAndToken(url: URLManager.sharedUrlManager.makeReschedule, details: confirmBook) {
            response in
            switch response.result {
            case .success(let value):
                if let status =  response.response?.statusCode {
                    print("status issw ..\(status)")
                    print("value...\(value)")
                    if status == 200 || status == 201 {
                        let val = JSON(value)
                        print("successfully rescheduled")
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
    func confirmBooking(){
        
        slotDetails = UserDefaults.standard.value(forKey: "dict") as! [String: Any]
        userSubId = UserDefaults.standard.object(forKey: "subjectId") as! [String]
        classTypeId = UserDefaults.standard.string(forKey: "classType") ?? ""
        
        guruId = UserDefaults.standard.string(forKey: "guruId") ?? ""
        
        
        for timeSlot in getSubjectSlots{
            let timeString: String = timeSlot["start"] as? String ?? ""
            
            self.getTimeSlot.append(String(timeString.prefix(3)))
            
        }
        print("got subjectt...\(getTimeSlot)")
        
        confirmBook["subject"] = userSubId
        confirmBook["timeSlotFrom"] = StructOperation.glovalVariable.timeSlotFrom
        confirmBook["classType"] = classTypeId
        if bookDemo == true{
            confirmBook["is_demo"] = "1"
        }else{
            confirmBook["is_demo"] = "0"
        }
        
        confirmBook["facultyId"] = guruId
        confirmBook["studentId"] = "2"
        
        //        confirmBook["studentId"] = StructOperation.glovalVariable.studentId
        confirmBook["noOfHours"] = getTimeSlot
        //               confirmBook["hourlyCompensation"] = guruFare
        confirmBook["hourlyCompensation"] = UserDefaults.standard.string(forKey: "totalFare")
        confirmBook["classes"] = StructOperation.glovalVariable.subjectDatesSlot
        
        print("confirm schedule book...\(confirmBook)")
        
        //        parentDetails["mobileNo"] = UserDefaults.standard.string(forKey: Constants.mobileNo)
        AlamofireService.alamofireService.postRequestWithBodyDataAndToken(url: URLManager.sharedUrlManager.makeBooking, details: confirmBook) {
            response in
            switch response.result {
            case .success(let value):
                if let status =  response.response?.statusCode {
                    print("status issw ..\(status)")
                    print("value...\(value)")
                    if status == 200 || status == 201 {
                        
                        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                        print("book successfully")
                        // pop alert controller
                        let alert = UIAlertController(title: "Booking", message: "Booked successfully", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                            self.navigationController?.popToRootViewController(animated: true)
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        //print("get sub...\(self.getSubjects)")
                        
                        DispatchQueue.main.async {
                            
                            self.tableView.reloadData()
                        }
                        
                    }
                    if status == 400{
                        // pop alert controller
                        let val = JSON(value)
                        let alert = UIAlertController(title: "Booking", message: "\(val["message"])", preferredStyle: UIAlertController.Style.alert)
                       
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
            case .failure( _):
                print("failure...\(response.result)")
                return
            }
        }
        
        
        print("confirm")
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if bookDemo == false{
            return getSubjectSlots.count + 3
        }else if reschedle == true{
            return 3
        }
        else{
            return getSubjectSlots.count + 2
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch reschedle{
        case false:
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "confirmSheduleFirst", for: indexPath) as!
                confirmSheduleFirstTableViewCell
                cell.guruName.text = guruProfileDetails[0].name
                cell.GuruSkills.text = guruProfileDetails[0].languagesKnown
                cell.guruContainer.layer.cornerRadius = 8
                cell.GuruFare.text = guruFare + "/ Hr"
                cell.currentMonth.text = currentMonth
                cell.currentMonth.layer.cornerRadius = 5
                cell.selectionStyle = .none
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
                    cell.subjectContainer.layer.cornerRadius = 5
                    cell.subjectName.text = getSubjectSlots[indexPath.row - 1]["name"] as? String
                    cell.subjectTime.text =  getSubjectSlots[indexPath.row - 1]["start"] as? String
                    cell.selectionStyle = .none
                    return cell
                }else{
                    return UITableViewCell()
                }
                
            }else if indexPath.row == getSubjectSlots.count + 1 && bookDemo == false{
                let cell = tableView.dequeueReusableCell(withIdentifier: "confirmScheduleThird", for: indexPath) as! confirmScheduleThirdTableViewCell
                cell.totalAmount.text = guruFare
                cell.grandTotalAmount.text = String(Int(getSubjectSlots.count) * Int(guruFare)!)
                cell.noOfClass.text = String(getSubjectSlots.count)
                cell.totalContainer.layer.cornerRadius = 5
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "customButton", for: indexPath) as! customButtonTableViewCell
                cell.goToDelegate = self
                return cell
            }
        case true:
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "confirmSheduleFirst", for: indexPath) as!
                confirmSheduleFirstTableViewCell
                cell.currentMonth.text = currentMonth
                cell.currentMonth.layer.cornerRadius = 5
                cell.selectionStyle = .none
                cell.guruName.text = StructOperation.glovalVariable.facultyName
                cell.GuruSkills.text =  StructOperation.glovalVariable.languageKnowns
                if let ratings = Int(StructOperation.glovalVariable.facultyRating){
                    if ratings < 5 && ratings > 4{
                        cell.fifthStarRating.image = UIImage(named: "halfStar")
                    }else if ratings == 5{
                        cell.fifthStarRating.isHidden = false
                        cell.fourthStarRating.isHidden = false
                        cell.thirdStarRating.isHidden = false
                        cell.secondStarRating.isHidden = false
                        cell.firstStarRating.isHidden = false
                    }else if ratings < 4 && ratings > 3{
                        cell.fifthStarRating.isHidden = true
                        cell.fourthStarRating.image = UIImage(named: "halfStar")
                    }else if ratings == 4{
                        cell.fifthStarRating.isHidden = false
                    }else if ratings < 3 && ratings > 2{
                        cell.fifthStarRating.isHidden = true
                        cell.fourthStarRating.isHidden = true
                        cell.thirdStarRating.image = UIImage(named: "halfStar")
                    }else if ratings == 3{
                        cell.fifthStarRating.isHidden = false
                        cell.fourthStarRating.isHidden = false
                    }else if ratings < 2 && ratings > 1{
                        cell.fifthStarRating.isHidden = true
                        cell.fourthStarRating.isHidden = true
                        cell.thirdStarRating.isHidden = true
                        cell.secondStarRating.image = UIImage(named: "halfStar")
                    }else{
                        cell.fifthStarRating.isHidden = true
                        cell.fourthStarRating.isHidden = true
                        cell.thirdStarRating.isHidden = true
                        cell.secondStarRating.isHidden = true
                    }
                }
                
                //cell.GuruFare.text = guruFare
                cell.configure(with: self.selectedDate)
                //            DispatchQueue.main.async {
                //                cell.selectedDate1 = self.selectedDate
                //                cell.datesCV.reloadData()
                //                cell.getLoad()
                //            }
                return cell
            }else if indexPath.row == 1{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmScheduleSecond", for: indexPath) as! ConfirmScheduleSecondTableViewCell
                cell.subjectContainer.layer.cornerRadius = 5
                cell.selectionStyle = .none
                cell.subjectName.text = StructOperation.glovalVariable.forRescheduleSubjectName
                cell.subjectTime.text =  StructOperation.glovalVariable.reScheduleTimeSlotFrom
                return cell
                
                
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "customButton", for: indexPath) as! customButtonTableViewCell
                cell.goToDelegate = self
                return cell
            }
        default:
            return UITableViewCell()
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if reschedle == false{
            if indexPath.row == getSubjectSlots.count + 2{
                return 90
            }else{
                return UITableView.automaticDimension
            }
        }else{
            return UITableView.automaticDimension
        }
        
        
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension ConfirmScheduleViewController: nextScreen{
    func gotoScreen() {
        if reschedle == false{
            confirmBooking()
            print("clicked confirmBooking..\(StructOperation.glovalVariable.points)")
        }else{
            reSchedule()
            print("clicked reSchedule")
        }
        
        
        
        
    }
    
    
}
