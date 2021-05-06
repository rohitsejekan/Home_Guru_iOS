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

class MyClassesDetailsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var backBtn: UIButton!
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
    var daysLeft: Int = 0
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
    var starValidate = false
    var starValidateSecond = false
    var starValidateThird = false
    var starValidateFourth = false
    var starValidateFifth = false
    var ratingStar: String = ""
    //rating starend
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var ratingViewBottom: NSLayoutConstraint!
    //var daysleft: String = ""
    @IBOutlet weak var queryField: UITextField!
    
    @IBOutlet weak var ratingQuery: UITextView!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var bottomView: NSLayoutConstraint!
    var cancelClass = [String: String]()
    @IBOutlet weak var navlabel: UILabel!
    var queryString: String = ""
    var ratingString: String = ""
    var feedBack = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //showNavbar()
        tableView.estimatedRowHeight = 120.0
        tableView.rowHeight = UITableView.automaticDimension
        //back btn
        backBtn.layer.cornerRadius = 8
        //back btn ends
        
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
        //rating textfield delegate
        ratingQuery.text = "Add feedback here...."
        ratingQuery.textColor = UIColor.lightGray
        ratingQuery.delegate = self
        
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
        if ratingViewBottom.constant == 0{
            ratingViewBottom.constant = -400
        }
    }
    @IBAction func addRating(_ sender: UIButton) {
        feedback()
    }
    func joinMeeting(){
        
        activityIndicatorView.startAnimating()
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
                            self.activityIndicatorView.stopAnimating()
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
          let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "ReScheduleViewController") as! ReScheduleViewController
            //setNavigationBackTitle(title: "Schedule")
            vc.hidesBottomBarWhenPushed = true
            
            
            self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isDemo == "1" && classStatus == "upcoming" && daysLeft == 0 {
            return 1
        }else if isDemo == "0" && classStatus == "upcoming" && daysLeft == 0{
            return 1
        }else if classStatus == "upcoming" && isDemo == "0" && daysLeft > 0{
            return 2
        }
        else{
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
//        if indexPath.row == 1{
//            let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "ReScheduleViewController") as! ReScheduleViewController
//            //setNavigationBackTitle(title: "Schedule")
//            vc.hidesBottomBarWhenPushed = true
//
//
//            self.navigationController?.pushViewController(vc, animated: false)
//        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if classStatus == "upcoming" && isDemo == "0" && daysLeft > 0{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleClassDetailsTableViewCell", for: indexPath) as! ScheduleClassDetailsTableViewCell
                cell.teacherNameLabel.text = facultyName
                cell.subjectLabel.text = subject
                cell.dateLabel.text = scheduledate
               
                // date display
                if daysLeft == 0{
                    cell.daysLeftLabel.text = "Today"
                }else{
                    cell.daysLeftLabel.text = String(daysLeft) + " days left"
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
                    cell.classTypeImageView.image = UIImage(named: "onlineWhite")
                    cell.classTypeLabel.text = "Online Class"
                }else{
                    cell.classTypeImageView.image = UIImage(named: "whiteAtHome")
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
        }else if isDemo == "1" && classStatus == "upcoming" && daysLeft == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleClassDetailsTableViewCell", for: indexPath) as! ScheduleClassDetailsTableViewCell
            cell.teacherNameLabel.text = facultyName
            cell.subjectLabel.text = subject
            cell.dateLabel.text = scheduledate
            // date display
            if daysLeft == 0{
                cell.daysLeftLabel.text = "toady"
            }else{
                cell.daysLeftLabel.text = String(daysLeft) + " days left"
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
        }else if isDemo == "0" && classStatus == "upcoming" && daysLeft == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleClassDetailsTableViewCell", for: indexPath) as! ScheduleClassDetailsTableViewCell
            cell.teacherNameLabel.text = facultyName
            cell.subjectLabel.text = subject
            cell.dateLabel.text = scheduledate
            // date display
            if daysLeft == 0{
                cell.daysLeftLabel.text = "Today"
            }else{
                cell.daysLeftLabel.text = String(daysLeft) + " days left"
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
                if daysLeft == 0{
                    cell.daysLeftLabel.text = "Today"
                }else{
                    cell.daysLeftLabel.text = String(daysLeft) + " days left"
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
                if daysLeft == 0{
                    cell.daysLeftLabel.text = "Today"
                }else{
                    cell.daysLeftLabel.text = String(daysLeft) + " days left"
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
                if daysLeft == 0{
                    cell.daysLeftLabel.text = "Today"
                }else{
                    cell.daysLeftLabel.text = String(daysLeft) + " days left"
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
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshCancel"), object: nil)                            // refresh tableview of myclassviewcontroller ends
                            
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
                starValidate = false
                ratingStarFirst.setImage(UIImage(named: "starplaceholder"), for: .normal)
                
                //sender.setTitleColor(.green, for: .normal)
            } else {
                starValidate = true
                ratingStarFirst.setImage(UIImage(named: "star"), for: .normal)
                ratingStar = "1"
                //sender.setTitleColor(.red, for: .normal)
            }
            if starValidate == false{
                ratingStar = "0"
                ratingStarSecond.setImage(UIImage(named: "starplaceholder"), for: .normal)
                ratingStarThird.setImage(UIImage(named: "starplaceholder"), for: .normal)
                ratingStarFourth.setImage(UIImage(named: "starplaceholder"), for: .normal)
                 ratingStarFifth.setImage(UIImage(named: "starplaceholder"), for: .normal)
            }
        }else if sender.tag == 1{
            if starValidate{
                isCheckedfsecond = !isCheckedfsecond
                          if isCheckedfsecond {
                            starValidateSecond = false
                              ratingStarSecond.setImage(UIImage(named: "starplaceholder"), for: .normal)
                              //sender.setTitleColor(.green, for: .normal)
                          } else {
                              starValidateSecond = true
                            ratingStar = "2"
                              ratingStarSecond.setImage(UIImage(named: "star"), for: .normal)
                              //sender.setTitleColor(.red, for: .normal)
                          }
                if starValidateSecond == false{
                    ratingStar = "0"
                    ratingStarThird.setImage(UIImage(named: "starplaceholder"), for: .normal)
                    ratingStarFourth.setImage(UIImage(named: "starplaceholder"), for: .normal)
                     ratingStarFifth.setImage(UIImage(named: "starplaceholder"), for: .normal)
                }

            }
          
        }else if sender.tag == 2{
            if starValidateSecond{
                isCheckedthird = !isCheckedthird
                         if isCheckedthird {
                            starValidateThird = false
                             ratingStarThird.setImage(UIImage(named: "starplaceholder"), for: .normal)
                             //sender.setTitleColor(.green, for: .normal)
                         } else {
                            ratingStar = "3"
                             starValidateThird = true
                             ratingStarThird.setImage(UIImage(named: "star"), for: .normal)
                             //sender.setTitleColor(.red, for: .normal)
                         }
            }
            if starValidateThird == false{
                ratingStar = "0"
                ratingStarFourth.setImage(UIImage(named: "starplaceholder"), for: .normal)
                 ratingStarFifth.setImage(UIImage(named: "starplaceholder"), for: .normal)
            }

         
        }else if sender.tag == 3{
            if starValidateThird{
                isCheckedfourth = !isCheckedfourth
                         if isCheckedfourth {
                            starValidateFourth = true
                             ratingStarFourth.setImage(UIImage(named: "starplaceholder"), for: .normal)
                             //sender.setTitleColor(.green, for: .normal)
                         } else {
                            ratingStar = "4"
                             starValidateFourth = false
                             ratingStarFourth.setImage(UIImage(named: "star"), for: .normal)
                             //sender.setTitleColor(.red, for: .normal)
                         }
            }
            if starValidateFourth == false{
                          ratingStar = "0"
                            ratingStarFifth.setImage(UIImage(named: "starplaceholder"), for: .normal)
                       }
         
        }else{
            if starValidateFourth{
                isCheckedfifth = !isCheckedfifth
                       if isCheckedfifth {
                        starValidateFifth = false
                           ratingStarFifth.setImage(UIImage(named: "starplaceholder"), for: .normal)
                           //sender.setTitleColor(.green, for: .normal)
                       } else {
                           starValidateFifth = true
                           ratingStar = "5"
                           ratingStarFifth.setImage(UIImage(named: "star"), for: .normal)
                           //sender.setTitleColor(.red, for: .normal)
                       }
                if starValidateFifth == false{
                    ratingStar = "0"
                }
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
extension MyClassesDetailsViewController: UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        ratingString = textView.text!
        print("text...\(ratingString)")
        
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
       
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
}
extension MyClassesDetailsViewController{
    func feedback(){
        feedBack["classId"] = StructOperation.glovalVariable.classId
        feedBack["feedback"] = ratingString
        feedBack["rating"] = ratingStar
        feedBack["facultyId"] = StructOperation.glovalVariable.facultyId
              activityIndicatorView.startAnimating()
              //        parentDetails["mobileNo"] = UserDefaults.standard.string(forKey: Constants.mobileNo)
              print("cancel body....\(cancelClass)")
              AlamofireService.alamofireService.postRequestWithBodyDataAndToken(url: URLManager.sharedUrlManager.feedBack, details: cancelClass) {
                  response in
                  switch response.result {
                  case .success(let value):
                      if let status =  response.response?.statusCode {
                          print("status issw ..\(status)")
                          print("value...\(value)")
                          if status == 200 || status == 201 {
                              
                              print("successfully feedbacked")
                              let alert = UIAlertController(title: "Booking", message: "Class Canceled successfully", preferredStyle: UIAlertController.Style.alert)
                              alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                                  // refresh tableview of myclassviewcontroller
                                  
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
}
