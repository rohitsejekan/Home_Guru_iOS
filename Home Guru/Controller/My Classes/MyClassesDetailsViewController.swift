//
//  MyClassesDetailsViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 16/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import SwiftyJSON
import NVActivityIndicatorView
import Kingfisher
protocol refreshProtocol: class{
    func refreshTableView()
}
class MyClassesDetailsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var scheduledClassInfo : [String:Any] = [:]
    var count = 2
    var showData : Bool = true
    var facultyName: String = ""
    var subject: String = ""
    var scheduledate: String = ""
    var scheduleTime: String = ""
    var classStatus: String = ""
    var classId: String = ""
    var classType: String = ""
    var profilePic: String = ""
    var isDemo: String = ""
    //rating star
    @IBOutlet weak var ratingStarFirst: UIButton!
    @IBOutlet weak var ratingStarSecond: UIButton!
    @IBOutlet weak var ratingStarThird: UIButton!
    @IBOutlet weak var ratingStarFourth: UIButton!
    @IBOutlet weak var ratingStarFifth: UIButton!
    var isCheckedfirst = true
    var isCheckedfsecond = true
    var isCheckedthird = true
    var isCheckedfourth = true
    var isCheckedfifth = true
    
    //rating starend
    weak var refreshDelegate: refreshProtocol?
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var ratingViewBottom: NSLayoutConstraint!
    var daysleft: String = ""
    @IBOutlet weak var queryField: UITextField!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var bottomView: NSLayoutConstraint!
    var cancelClass = [String: String]()
    @IBOutlet weak var navlabel: UILabel!
    var queryString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //showNavbar()
        tableView.estimatedRowHeight = 120.0
        tableView.rowHeight = UITableView.automaticDimension
        //cancelbtn
        cancelBtn.layer.cornerRadius = 7
        // custom cell
        tableView.register(UINib(nibName: "ScheduleClassDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "ScheduleClassDetailsTableViewCell")
        // popview
        popView.layer.cornerRadius = 10
        print("classid...\(classId)")
        // Do any additional setup after loading the view.
        navlabel.text = scheduledate
        print("stu id....\(StructOperation.glovalVariable.studentId)")
        print("fac id....\(StructOperation.glovalVariable.facultyId)")
        print("fac charge....\(StructOperation.glovalVariable.subjectId)")
        print("sub charge....\(StructOperation.glovalVariable.hourlyCompenstaion)")
        //class status
        print("class status  .....\(classStatus)")
        // textfield delegate
        queryField.delegate = self
        // get demo value 1 0r 0
        isDemo = StructOperation.glovalVariable.isDemo
        
        print("profilePic...\(profilePic)")
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //        getCellCount()
        print("classid..\(StructOperation.glovalVariable.classId)")
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
        if classStatus == "upcoming" && isDemo == "0"{
            reScheduleClass()
        }else if classType == "2" && classStatus == "ongoing" && isDemo == "1"{
            joinMeeting()
        }else if classType == "2" && classStatus == "ongoing" && isDemo == "0"{
            joinMeeting()
        }
        
    }
    @IBAction func ratingBtnCancel(_ sender: UIButton) {
        if ratingViewBottom.constant == -400{
            ratingViewBottom.constant = 0
        }
    }
    func joinMeeting(){
        
        AlamofireService.alamofireService.getRequestWithSecretKey(url: URLManager.sharedUrlManager.getZoomId + "classId=\(classId)", parameters: nil) { response
            in
            switch response.result {
            case .success(let value):
                if let status =  response.response?.statusCode {
                    print("status is ..\(status)")
                    let json = JSON(value)
                    print("password..\(json["faculty"]["password"].stringValue )")
                    if status == 200 || status == 201 {
                        print("join..\(value)")
                        DispatchQueue.main.async {
                            let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "zoomViewController") as! zoomViewController
                            vc.meetPassword = json["faculty"]["password"].stringValue
                            vc.meetId = json["faculty"]["zoomMeeting"].stringValue
                            //setNavigationBackTitle(title: "Schedule")
                            self.navigationController?.pushViewController(vc, animated: false)
                        }
                    }
                }
            case .failure( _):
                self.showAlert(title: Constants.unknownTitle, message: Constants.unknownMsg)
            }
        }
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
        if isDemo == "1" && classStatus == "upcoming"{
            return 1
        }else{
            return showData ? count : 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            return 140
        }
        return UITableView.automaticDimension
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
        if classStatus == "upcoming"{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleClassDetailsTableViewCell", for: indexPath) as! ScheduleClassDetailsTableViewCell
                cell.teacherNameLabel.text = facultyName
                cell.subjectLabel.text = subject
                cell.dateLabel.text = scheduledate
                // date display
                if daysleft == "0"{
                    cell.daysLeftLabel.text = "Today"
                }else{
                    cell.daysLeftLabel.text = daysleft + " days left"
                }
                
                if profilePic != ""{
                    let url = URL(string: profilePic)
                    cell.classImageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
                    cell.classImageView.kf.indicatorType = .activity
                }else{
                    cell.classImageView.image = UIImage(named: "Avatar 2")
                }
                
                if let weekday = getDayOfWeek(scheduledate) {
                    cell.dayLabel.text = String(weekday.prefix(3))
                } else {
                    print("bad input")
                }
                if classType == "1"{
                    cell.classTypeLabel.text = "Online Class"
                }else{
                    cell.classTypeLabel.text = "At Home Clases"
                }
                cell.timeLabel.text = scheduleTime
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "classDetailsAction", for: indexPath) as! classDetailsActionTableViewCell
                cell.selectionStyle = .none
                return cell
            }
        }else if isDemo == "1" && classStatus == "upcoming" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleClassDetailsTableViewCell", for: indexPath) as! ScheduleClassDetailsTableViewCell
            cell.teacherNameLabel.text = facultyName
            cell.subjectLabel.text = subject
            cell.dateLabel.text = scheduledate
            // date display
            if daysleft == "Today"{
                cell.daysLeftLabel.text = daysleft
            }else{
                cell.daysLeftLabel.text = daysleft + " days left"
            }
            
            if profilePic != ""{
                let url = URL(string: profilePic)
                cell.classImageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
                cell.classImageView.kf.indicatorType = .activity
            }else{
                cell.classImageView.image = UIImage(named: "Avatar 2")
            }
            
            if let weekday = getDayOfWeek(scheduledate) {
                cell.dayLabel.text = String(weekday.prefix(3))
            } else {
                print("bad input")
            }
            if classType == "1"{
                cell.classTypeLabel.text = "Online Class"
            }else{
                cell.classTypeLabel.text = "At Home Clases"
            }
            cell.timeLabel.text = scheduleTime
            cell.selectionStyle = .none
            return cell
        }
        else if isDemo == "1" && classStatus == "ongoing" && classType == "2"{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleClassDetailsTableViewCell", for: indexPath) as! ScheduleClassDetailsTableViewCell
                cell.teacherNameLabel.text = facultyName
                cell.subjectLabel.text = subject
                cell.dateLabel.text = scheduledate
                // date display
                if daysleft == "Today"{
                    cell.daysLeftLabel.text = daysleft
                }else{
                    cell.daysLeftLabel.text = daysleft + " days left"
                }
                
                if profilePic != ""{
                    let url = URL(string: profilePic)
                    cell.classImageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
                    cell.classImageView.kf.indicatorType = .activity
                }else{
                    cell.classImageView.image = UIImage(named: "Avatar 2")
                }
                
                if let weekday = getDayOfWeek(scheduledate) {
                    cell.dayLabel.text = String(weekday.prefix(3))
                } else {
                    print("bad input")
                }
                if classType == "1"{
                    cell.classTypeLabel.text = "Online Class"
                }else{
                    cell.classTypeLabel.text = "At Home Clases"
                }
                cell.timeLabel.text = scheduleTime
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "classDetailsAction", for: indexPath) as! classDetailsActionTableViewCell
                cell.cancelScheduleBtn.isHidden = true
                cell.reScheduleBtn.setTitle("JOIN CLASS", for: .normal)
                cell.selectionStyle = .none
                return cell
            }
            
        }else if isDemo == "0" && classStatus == "ongoing" && classType == "2"{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleClassDetailsTableViewCell", for: indexPath) as! ScheduleClassDetailsTableViewCell
                cell.teacherNameLabel.text = facultyName
                cell.subjectLabel.text = subject
                cell.dateLabel.text = scheduledate
                // date display
                if daysleft == "Today"{
                    cell.daysLeftLabel.text = daysleft
                }else{
                    cell.daysLeftLabel.text = daysleft + " days left"
                }
                
                if profilePic != ""{
                    let url = URL(string: profilePic)
                    cell.classImageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
                    cell.classImageView.kf.indicatorType = .activity
                }else{
                    cell.classImageView.image = UIImage(named: "Avatar 2")
                }
                
                if let weekday = getDayOfWeek(scheduledate) {
                    cell.dayLabel.text = String(weekday.prefix(3))
                } else {
                    print("bad input")
                }
                if classType == "1"{
                    cell.classTypeLabel.text = "Online Class"
                }else{
                    cell.classTypeLabel.text = "At Home Clases"
                }
                cell.timeLabel.text = scheduleTime
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "classDetailsAction", for: indexPath) as! classDetailsActionTableViewCell
                cell.cancelScheduleBtn.isHidden = true
                cell.reScheduleBtn.setTitle("JOIN CLASS", for: .normal)
                cell.selectionStyle = .none
                return cell
            }
        }
            
        else{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleClassDetailsTableViewCell", for: indexPath) as! ScheduleClassDetailsTableViewCell
                cell.teacherNameLabel.text = facultyName
                cell.subjectLabel.text = subject
                cell.dateLabel.text = scheduledate
                // date display
                if daysleft == "Today"{
                    cell.daysLeftLabel.text = daysleft
                }else{
                    cell.daysLeftLabel.text = daysleft + " days left"
                }
                
                if profilePic != ""{
                    let url = URL(string: profilePic)
                    cell.classImageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
                    cell.classImageView.kf.indicatorType = .activity
                }else{
                    cell.classImageView.image = UIImage(named: "Avatar 2")
                }
                
                if let weekday = getDayOfWeek(scheduledate) {
                    cell.dayLabel.text = String(weekday.prefix(3))
                } else {
                    print("bad input")
                }
                if classType == "1"{
                    cell.classTypeLabel.text = "Online Class"
                }else{
                    cell.classTypeLabel.text = "At Home Clases"
                }
                cell.timeLabel.text = scheduleTime
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "classDetailsAction", for: indexPath) as! classDetailsActionTableViewCell
                cell.cancelScheduleBtn.isHidden = true
                cell.reScheduleBtn.setTitle("JOIN CLASS", for: .normal)
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    @IBAction func cancelClass(_ sender: UIButton) {
        cancelClass["classId"] = StructOperation.glovalVariable.classId
        cancelClass["cancellationReason"] = queryString
        activityIndicatorView.startAnimating()
        //        parentDetails["mobileNo"] = UserDefaults.standard.string(forKey: Constants.mobileNo)
        print("cancel body....\(cancelClass)")
        AlamofireService.alamofireService.postRequestWithBodyDataAndToken(url: URLManager.sharedUrlManager.cancelSchedule, details: cancelClass) {
            response in
            switch response.result {
            case .success(let value):
                if let status =  response.response?.statusCode {
                    print("status issw ..\(status)")
                    print("value...\(value)")
                    if status == 200 || status == 201 {
                        
                        print("successfully canceled")
                        let alert = UIAlertController(title: "Booking", message: "Class Canceled successfully", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                            // refresh tableview of myclassviewcontroller
                            self.refreshDelegate?.refreshTableView()
                            // refresh tableview of myclassviewcontroller ends
                            
                            self.navigationController?.popToRootViewController(animated: true)
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                        //print("get sub...\(self.getSubjects)")
                        DispatchQueue.main.async {
                            self.activityIndicatorView.stopAnimating()
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
    @IBAction func cancelSchedule(_ sender: UIButton) {
        if bottomView.constant == 375{
            bottomView.constant = 0
        }
        
    }
    
    @IBAction func removePopView(_ sender: UIButton) {
        if bottomView.constant == 0{
            bottomView.constant = 375
        }
    }
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    // rating1
    @IBAction func rateClass(_ sender: UIButton) {
        if sender.tag == 0{
            isCheckedfirst = !isCheckedfirst
            if isCheckedfirst {
                ratingStarFirst.setImage(UIImage(named: "fullStar"), for: .normal)
                //sender.setTitleColor(.green, for: .normal)
            } else {
                
                ratingStarFirst.setImage(UIImage(named: ""), for: .normal)
                //sender.setTitleColor(.red, for: .normal)
            }
        }else if sender.tag == 1{
            isCheckedfsecond = !isCheckedfsecond
            if isCheckedfsecond {
                ratingStarSecond.setImage(UIImage(named: "fullStar"), for: .normal)
                //sender.setTitleColor(.green, for: .normal)
            } else {
                
                ratingStarSecond.setImage(UIImage(named: ""), for: .normal)
                //sender.setTitleColor(.red, for: .normal)
            }
        }else if sender.tag == 2{
            isCheckedthird = !isCheckedthird
            if isCheckedthird {
                ratingStarThird.setImage(UIImage(named: "fullStar"), for: .normal)
                //sender.setTitleColor(.green, for: .normal)
            } else {
                
                ratingStarThird.setImage(UIImage(named: ""), for: .normal)
                //sender.setTitleColor(.red, for: .normal)
            }
        }else if sender.tag == 3{
            isCheckedfourth = !isCheckedfourth
            if isCheckedfourth {
                ratingStarFourth.setImage(UIImage(named: "fullStar"), for: .normal)
                //sender.setTitleColor(.green, for: .normal)
            } else {
                
                ratingStarFourth.setImage(UIImage(named: ""), for: .normal)
                //sender.setTitleColor(.red, for: .normal)
            }
        }else{
            isCheckedfifth = !isCheckedfifth
            if isCheckedfifth {
                ratingStarFifth.setImage(UIImage(named: "fullStar"), for: .normal)
                //sender.setTitleColor(.green, for: .normal)
            } else {
                
                ratingStarFifth.setImage(UIImage(named: ""), for: .normal)
                //sender.setTitleColor(.red, for: .normal)
            }
        }
    }
    
}

extension MyClassesDetailsViewController{
    func getDayOfWeek(_ today:String) -> String? {
        let df  = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        let date = df.date(from: today)!
        df.dateFormat = "EEEE"
        return df.string(from: date);
    }
}
extension MyClassesDetailsViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        queryString = textField.text!
        print("text....\(queryString)")
    }
}
