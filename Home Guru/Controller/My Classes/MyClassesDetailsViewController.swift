//
//  MyClassesDetailsViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 16/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit

class MyClassesDetailsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var scheduledClassInfo : [String:Any] = [:]
    var count = 2
    var showData : Bool = true
    var facultyName: String = ""
    var subject: String = ""
    var scheduledate: String = ""
    var scheduleTime: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //showNavbar()
        tableView.estimatedRowHeight = 120.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "ScheduleClassDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "ScheduleClassDetailsTableViewCell")
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        getCellCount()
    }
    
    func getCellCount() {
//        scheduledClassInfo["startOnlineClass"] = false
//        scheduledClassInfo["currentClass"] = false
//        print("scheduledClassInfo[\"dateObj\"] \(scheduledClassInfo["dateObj"])")
//        if (scheduledClassInfo["dateObj"] as! Date) == Date() {
//            scheduledClassInfo["currentClass"] = true
//            if let date = scheduledClassInfo["date"] as? String {
//                if let from = scheduledClassInfo["timeSlotFrom"] as? String, let to = scheduledClassInfo["timeSlotTo"] as? String {
//                    if isBetweenTwoTimeRange(from: getDateString(format: "yyyy/MM/dd HH:mm:ss", date: getFiveMinutesTimeBeforeGivenTime(startDate: scheduledClassInfo["dateObj"] as! Date)), to: date.replacingOccurrences(of: "-", with: "/") + " " + from) {
//                        if let classTypeData = scheduledClassInfo["classType"] as? [String:Any] {
//                            if let classType = classTypeData["name"] as? String {
//                                count = classType == "Online Class" ? 2 : 1
//                                scheduledClassInfo["startOnlineClass"] = classType == "Online Class" ? true : false
//                            }
//                        }
//
//                    } else if isBetweenTwoTimeRange(from: date.replacingOccurrences(of: "-", with: "/") + " " + from, to: date.replacingOccurrences(of: "-", with: "/") + " " + to) {
//                        count = 1
//                    }
//                }
//            }
//        } else if (scheduledClassInfo["dateObj"] as! Date) < Date() {
//            count = 2
//        } else {
//            let previousDay = getPreviousDayFromStartDate(startDate: scheduledClassInfo["dateObj"] as! Date)
//            if let date = scheduledClassInfo["date"] as? String {
//                if let from = scheduledClassInfo["timeSlotFrom"] as? String {
//                    if isBetweenTwoTimeRange(from: getDateString(format: "yyyy/MM/dd HH:mm:ss", date: previousDay),to: date.replacingOccurrences(of: "-", with: "/") + " " + from) {
//                        count = 2
//                    } else {
//                        count = 1
//                    }
//                }
//            }
//        }
    }
    
    
    @IBAction func rescheduleAction(_ sender: UIButton) {
        reScheduleClass()
    }
    
    func reScheduleClass() {
//        var details : [String:String] = [:]
//        if let classId = scheduledClassInfo["_id"] as? String, let dateId =  scheduledClassInfo["date_id"] as? String {
//            details["class"] = classId
//            details["dateId"] = dateId
//        }
//        let hud = showLoader(onView: tableView)
//        if !isNetConnectionAvailable() {
//            self.hideLoader(loader: hud)
//            self.showAlert(title: "Message", message: "Please Check Your Internet Connection!")
//            return
//        }
//        AlamofireService.alamofireService.postRequestWithBodyDataAndToken(url: URLManager.sharedUrlManager.rescheduleClass, details: details) {
//            response in
//            switch response.result {
//            case .success(let value):
//                if let status =  response.response?.statusCode {
//                    print("status is ..\(status)")
//                    if status == 200 || status == 201 {
//                        if let result = value as? [String:Any] {
//                            print("result is ...\(result)")
//                        }
//                        DispatchQueue.main.async {
//                            self.hideLoader(loader: hud)
//                            let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
//                            vc.details["title"]  = "Cancel Class"
//                            vc.details["msg"] = "Your request for class cancelation has been sent successfully!"
//                            vc.details["action"] = "HOME"
//                            self.navigationController?.pushViewController(vc, animated: true)
//                        }
//                    } else {
//                        self.hideLoader(loader: hud)
//                        self.showAlert(title: Constants.unknownTitle, message: Constants.unknownMsg)
//                    }
//                }
//            case .failure( _):
//                self.hideLoader(loader: hud)
//                self.showAlert(title: Constants.unknownTitle, message: Constants.unknownMsg)
//            }
//        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showData ? count : 0
    }
  
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1{
            let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "ReScheduleViewController") as! ReScheduleViewController
            //setNavigationBackTitle(title: "Schedule")
            vc.hidesBottomBarWhenPushed = true
           
         
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleClassDetailsTableViewCell", for: indexPath) as! ScheduleClassDetailsTableViewCell
            cell.teacherNameLabel.text = facultyName
            cell.subjectLabel.text = subject
            cell.dateLabel.text = scheduledate
            cell.timeLabel.text = scheduleTime
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "classDetailsAction", for: indexPath) as! classDetailsActionTableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
