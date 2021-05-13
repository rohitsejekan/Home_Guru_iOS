//
//  MyClassesViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 03/12/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import NVActivityIndicatorView
enum DataDisplayType {
    case homeInfo, scheduleInfo, registerInfo
}

class MyClassesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @objc func refresh() {
        DispatchQueue.main.async {
            self.getMyclassDetails() // a refresh the tableView.
        }
        
        
    }
    @objc func refreshReschedule(){
         DispatchQueue.main.async {
                   self.getMyclassDetails() // a refresh the tableView.
               }
    }
    
    @objc func refreshCancel(){
         DispatchQueue.main.async {
                   self.getMyclassDetails() // a refresh the tableView.
               }
    }
    
    @IBOutlet weak var activityLoaderView: NVActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    var overlayBool: Bool = false
    var myClassDetails = [myClasses?]()
    var points : Int = 0
    var refreshControl: UIRefreshControl!
    var scheduledClassInfo : [[String:Any]] = [["classType":"old class","dateObj":Date()],["classType":"today","dateObj":Date()],["classType":"not held","dateObj":Date()],["classType":"future", "dateObj":Date()],["classType":"future demo","dateObj":Date()]]
    var classDetails : [Int] = []
    var showData : Bool = false
    var dateString: String = ""
    let today = Date()
    var vSpinner : UIView?
    var todayTimeHour: Int?
    var todayTimeMin: Int?
    var dataDisplayType : DataDisplayType = .scheduleInfo
    //date formatter
    let dateFormatter = DateFormatter()
    //activity indicator
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        return formatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        let hh2 = (Calendar.current.component(.hour, from: Date()))
        let mm2 = (Calendar.current.component(.minute, from: Date()))
        print("time")
        todayTimeHour = hh2
        todayTimeMin = mm2
        print(todayTimeHour,":", todayTimeMin)
        
        //refresh cancel booking
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshCancel), name: NSNotification.Name(rawValue: "refreshCancel"), object: nil)
        //refresh booking
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        
        //refresh reschedule
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshReschedule), name: NSNotification.Name(rawValue: "refreshReschedule"), object: nil)
        
        //refresh tableview based on call from previous vc ends
        
        //token
        print("token...\(UserDefaults.standard.string(forKey: Constants.token))")
        //navigationController?.hidesBarsOnTap = true
        tableView.estimatedRowHeight = 400.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "ScheduledClassCardTableViewCell", bundle: nil), forCellReuseIdentifier: "ScheduledClassCardTableViewCell")
        navigationController?.delegate = self
        getMyclassDetails()
        
        print("today....\(dateFormatter2.date(from: "\(today)"))")
        let tomorrow = Date().dayAfter
        //Calculate the number of days between today and the user's chosen day.
        let difference = Calendar.current.dateComponents([.day], from: today, to: tomorrow)
        guard let days = difference.day else { return }
        let ess = days > 1 ? "s" : ""
        print("That date is \(days) day\(ess) away.")
        
        
        //  let components = cal.dateComponents(.Day, from: startDate, to: endDate, options: [])
        
        // print("dates...\(components)")
        print("stu id ...\(StructOperation.glovalVariable.studentId)")
        print("address...\(UserDefaults.standard.object(forKey: "userAddres"))")
        
        //pull up refresh
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshPull), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    @objc func refreshPull(_ sender: Any) {
        //  your code to reload tableView
        
            refreshControl.beginRefreshing()
            getMyclassDetails()
            refreshControl.endRefreshing()
        
        
    }
    func findDateDiff(time1Str: String, time2Str: String) -> Int {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm"
        
        guard let time1 = timeformatter.date(from: time1Str),
            let time2 = timeformatter.date(from: time2Str) else { return 0 }
        
        //You can directly use from here if you have two dates
        
        let interval = time2.timeIntervalSince(time1)
        let hour = (interval / 3600)*60;
        let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
        //let intervalInt = Int(interval)
        return Int(hour) + Int(minute)
    }
    
    func getMyclassDetails(){
        activityLoaderView.startAnimating()
        if let id = UserDefaults.standard.string(forKey: "studentId"){
            AlamofireService.alamofireService.getRequestWithToken(url: URLManager.sharedUrlManager.getMyClasses + "studentId=\(id)", parameters: nil) {
                response in
                switch response.result {
                case .success(let value):
                    if let status =  response.response?.statusCode {
                        print("guru p ..\(status)")
                        print("g p...\(value)")
                        if status == 200 || status == 201 {
                            
                            let val = JSON(value)
                            print("g p...\(value)")
                            if self.myClassDetails.isEmpty{
                               
                                
                                for arr in val.arrayValue{
                                    if let dateString = self.dateFormatter2.date(from: "\(arr["date"].stringValue)"){
                                        let difference = Calendar.current.dateComponents([.day], from: self.today, to: dateString)
                                        guard let days = difference.day else { return  }
                                        let ess = days > 1 ? "s" : ""
                                        print("That date is \(days) day\(ess) away.")
                                        if Int(days) > -2{
                                            print("date...\(arr["date"].stringValue)")
                                            if arr["status"].stringValue == "cancelled"{
                                                continue
                                            }
                                            print("is_demo....\(arr["is_demo"])")
                                            if arr["is_demo"] == 1{
                                                UserDefaults.standard.set("1", forKey: "classDemo")
                                                
                                            }
                                            print("ststus...\(arr["status"].stringValue)")
                                            print("classdemo....\(UserDefaults.standard.string(forKey: "classDemo"))")
                                            StructOperation.glovalVariable.parentEmail = arr["parent"]["email"].stringValue
                                            StructOperation.glovalVariable.parentPhone = arr["parent"]["mobileNo"].stringValue
                                            self.myClassDetails.append(myClasses(json: arr))
                                            // print("child sub...\(arr)")
                                        }
                                        
                                    }
                                    
                                }
                               
                               
                                
                            }else{
                                self.myClassDetails.removeAll()
                                self.getMyclassDetails()
                            }
                            
                            print("classes.......\(self.myClassDetails)")
                         
                            DispatchQueue.main.async {
                               //display homeinfo and scheduleinfo based on muclassDetails dictionary
                                if self.myClassDetails.isEmpty{
                                        print("empty true")
                                    self.dataDisplayType = .homeInfo
                                }else{
                                    self.dataDisplayType = .scheduleInfo
                                }
                                //display homeinfo and scheduleinfo based on muclassDetails dictionary
                                self.activityLoaderView.stopAnimating()
                                self.tableView.reloadData()
                            }
                        }
                    }
                case .failure( _):
                    self.activityLoaderView.stopAnimating()
                    self.dataDisplayType = .homeInfo
                    self.tableView.reloadData()
                    print("failure")
                    return
                }
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavbar()
        print("stu id...\(UserDefaults.standard.string(forKey: "studentId"))")
        self.navigationController?.navigationBar.frame = CGRect(x: 0,y: 0,width: 0,height: 0);
        //        if UserDefaults.standard.bool(forKey: Constants.isRegistered) {
        //            getScheduledClassInfo()
        //        } else {
        
        //display homeinfo and scheduleinfo based on muclassDetails dictionary
        
        //display homeinfo and scheduleinfo based on muclassDetails dictionary
        
        reloadData()
        //        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        hideNavbar()
    }
    
    
    func reloadData() {
        DispatchQueue.main.async {
            self.showData = true
            self.tableView.reloadData()
        }
    }
    
    @IBAction func bookClassAction(_ sender: UIButton) {
        let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "ScheduleViewController") as? ScheduleViewController
        //setNavigationBackTitle(title: "Schedule")
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        switch sender.currentTitle {
        case "BOOK CLASS":
            //            let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "RegisterParentViewController") as! RegisterParentViewController
            //            //setNavigationBackTitle(title: "Register")
            //            vc.hidesBottomBarWhenPushed = true
            //            self.present(vc, animated: true, completion: nil)
            
            let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "ScheduleViewController") as! ScheduleViewController
            //setNavigationBackTitle(title: "Schedule")
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: false)
            
        case "ADD CREDITS":
            print(".....")
            //            let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "AddCreditViewController") as? AddCreditViewController
            //            setNavigationBackTitle(title: "Koala Credits")
            //            vc!.points = points
        //            self.navigationController?.pushViewController(vc!, animated: false)
        default:
            print(".....")
            //            scheduleClass()
        }
    }
    
    
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return showData ? ((dataDisplayType == .homeInfo) ? 1 : (dataDisplayType == .registerInfo) ? 1 : scheduledClassInfo.count) : 0
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataDisplayType == .scheduleInfo{
            
            return myClassDetails.count + 1
        }else{
            return showData ? ((dataDisplayType == .homeInfo || dataDisplayType == .registerInfo) ? 1 : (( scheduledClassInfo.count == 0 ? 1 : scheduledClassInfo.count + 1))) : 0
        }
        
    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        if dataDisplayType == .homeInfo || dataDisplayType == .registerInfo {
    //            return UIView()
    //        }
    //        let view = Bundle.main.loadNibNamed("HomeScheduleHeaderView", owner: self, options: nil)?.first as! HomeScheduleHeaderView
    //        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
    //        view.dateLabel.text = getDateString(format: "MMM yyyy", date: scheduledClassInfo[section][0].key)
    //        view.dateLabel.textColor = (getDateString(format: "MMM", date: scheduledClassInfo[section][0].key) == "Aug") ? ColorPalette.koalaBlueColor : ColorPalette.textColor
    //        view.headerImageView.image = UIImage(named: getDateString(format: "MMM", date: scheduledClassInfo[section][0].key) + ".png")
    //        return view
    //    }
    
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return dataDisplayType == .homeInfo || dataDisplayType == .registerInfo ? 0.0 : 90.0
    //    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataDisplayType == .homeInfo || dataDisplayType == .registerInfo {
            return showHomeInfoData(tableView, cellForRowAt : indexPath)
        } else {
            return showScheduledClassInfo(tableView, cellForRowAt : indexPath)
        }
    }
    
    func showHomeInfoData(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyClassInfoTableViewCell", for: indexPath) as? MyClassInfoTableViewCell
        cell?.actionBtn.setTitle(dataDisplayType == .homeInfo ? "BOOK CLASS" : "REGISTER", for: .normal)
        cell?.actionBtn.layer.cornerRadius = 8
        cell?.selectionStyle = .none
        // cell?.bgImage.image = imageWithGradient(img:cell?.bgImage.image!)
        if overlayBool == false{
            cell!.overlayView.backgroundColor = ColorPalette.homeGuruBlueColor.withAlphaComponent(0.9)
            overlayBool = true
        }
        UserDefaults.standard.set("0", forKey: "classDemo")
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dataDisplayType == .homeInfo || dataDisplayType == .registerInfo {
            if indexPath.row == 0{
                tableView.isScrollEnabled = false
                return tableView.frame.height
            }else{
                return UITableView.automaticDimension
            }
            
        }else{
            tableView.isScrollEnabled = true
            return UITableView.automaticDimension
        }
        
        
    }
    func showScheduledClassInfo(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        if scheduledClassInfo[indexPath.row].isEmpty {
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as? NoDataTableViewCell
        //            cell?.msgLabel.text = "NO BOOKINGS YET"
        //            cell?.msgLabel.textColor = ColorPalette.textColor
        //            cell?.selectionStyle = .none
        //            return cell!
        //            return UITableViewCell()
        //        } else if indexPath.row == 0 {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyClassActionCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduledClassCardTableViewCell", for: indexPath) as? ScheduledClassCardTableViewCell
            // check is demo
            
            // check is demo ends
            cell?.moduleLabel.text = myClassDetails[indexPath.row - 1]?.subject[0].subjectName
            cell?.nameLabel.text = myClassDetails[indexPath.row - 1]?.faculty?.name
            cell?.dateLabel.text = myClassDetails[indexPath.row - 1]?.scheduleDate
            cell?.timeLabel.text = myClassDetails[indexPath.row - 1]?.timeSlotFrom
            cell?.selectionStyle = .none
            if myClassDetails[indexPath.row - 1]?.classType == "2"{
                cell?.classImageView.image = UIImage(named: "onlineWhite")
               // cell?.classImageView.backgroundColor = UIColor.
            }else{
                cell?.classImageView.image = UIImage(named: "whiteAtHome")
                
            }
            let mypoints = myClassDetails[indexPath.row - 1]?.faculty?.ratings ?? ""
            if let  ratings = Int(mypoints){
                if ratings < 5 && ratings > 4{
                    cell?.fifthStarImageView.image = UIImage(named: "halfStar")
                }else if ratings == 5{
                    cell?.fifthStarImageView.isHidden = false
                    cell?.fourthStarImageView.isHidden = false
                    cell?.thirdStarImageView.isHidden = false
                    cell?.secondStarImageView.isHidden = false
                    cell?.firstStarImageView.isHidden = false
                }else if ratings < 4 && ratings > 3{
                    cell?.fifthStarImageView.isHidden = true
                    cell?.fourthStarImageView.image = UIImage(named: "halfStar")
                }else if ratings == 4{
                    cell?.fifthStarImageView.isHidden = false
                }else if ratings < 3 && ratings > 2{
                    cell?.fifthStarImageView.isHidden = true
                    cell?.fourthStarImageView.isHidden = true
                    cell?.thirdStarImageView.image = UIImage(named: "halfStar")
                }else if ratings == 3{
                    cell?.fifthStarImageView.isHidden = false
                    cell?.fourthStarImageView.isHidden = false
                }else if ratings < 2 && ratings > 1{
                    cell?.fifthStarImageView.isHidden = true
                    cell?.fourthStarImageView.isHidden = true
                    cell?.thirdStarImageView.isHidden = true
                    cell?.secondStarImageView.image = UIImage(named: "halfStar")
                }else{
                    cell?.fifthStarImageView.isHidden = true
                    cell?.fourthStarImageView.isHidden = true
                    cell?.thirdStarImageView.isHidden = true
                    cell?.secondStarImageView.isHidden = true
                }
                
            }
            // calculting date difference between current date and scheduled date
            if let dateString = dateFormatter2.date(from: myClassDetails[indexPath.row - 1]?.scheduleDate ?? ""){
                
                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: dateString)
                let difference = Calendar.current.dateComponents([.day], from: today, to: tomorrow!)
                guard let days = difference.day else { return cell! }
                let ess = days > 1 ? "s" : ""
                print("That date iss \(days) day\(ess) away.")
                print("too...\(today)")
                print("too...\(myClassDetails[indexPath.row - 1]?.scheduleDate)")
                
                if Int(days) < 0 {
                    
                    
                    if myClassDetails[indexPath.row - 1]?.status == "completed"{
                        cell?.setCardValues(data: scheduledClassInfo[0])
                        if myClassDetails[indexPath.row - 1]?.faculty?.ratings == ""{
                            cell?.noOfDaysLeft.text = "Please rate the class"
                        }else{
                            cell?.noOfDaysLeft.text = "class completed!"
                        }
                        
                    }
                    if myClassDetails[indexPath.row - 1]?.status == "upcoming"{
                        cell?.setCardValues(data: scheduledClassInfo[0])
                        cell?.noOfDaysLeft.text = "Class was not engaged"
                    }
                    
                }else{
                    // set date left
                    if days == 0{
                        if let th = todayTimeHour, let tm = todayTimeMin{
                            print("..th...\(th)")
                            print("..tm...\(tm)")
                            print("..timeslot...\(myClassDetails[indexPath.row - 1]?.timeSlotFrom)")
                            // time difference of start class and current time
                            let timeDiff = findDateDiff(time1Str: "\(th):\(tm)", time2Str: myClassDetails[indexPath.row -  1]?.timeSlotFrom ?? "12:00")
                            // time difference of end time and current time
                            let timeDiffEnd = findDateDiff(time1Str: "\(th):\(tm)", time2Str: myClassDetails[indexPath.row -  1]?.timeSlotTo ?? "12:00")
                            print("..diff...\(timeDiffEnd)")
                            // display class not engaged based on current time passed the end time of scheduled class
                            if timeDiffEnd < 0{
                                if myClassDetails[indexPath.row - 1]?.status == "upcoming"{
                                    cell?.noOfDaysLeft.text = "Class not engaged"
                                }
                                
                            }
                            // display Please start the class based on current time passed the start time of scheduled class
                            
                            else if timeDiff < 0{
                                
                                if myClassDetails[indexPath.row - 1]?.status == "upcoming"{
                                    cell?.noOfDaysLeft.text = "Please start the class"
                                }
                            }else{
                                cell?.noOfDaysLeft.text = "Today"
                            }
                        }
                        
                    }else{
                        cell?.noOfDaysLeft.text = "\(days)" + " days left"
                    }
                    // set date left ends
                    
                    // change card color based on demo
                    if myClassDetails[indexPath.row - 1]?.is_demo == "1"{
                        cell?.setCardValues(data: scheduledClassInfo[4])
                    }else{
                        cell?.setCardValues(data: scheduledClassInfo[3])
                    }
                    
                }
            }
            
            if let weekday = getDayOfWeek(myClassDetails[indexPath.row - 1]?.scheduleDate ?? "") {
                cell?.dayLabel.text = String(weekday.prefix(3))
            }else{
                print("bad input")
            }
            
            cell?.selectionStyle = .none
            return cell!
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataDisplayType == .scheduleInfo {
            if indexPath.row != 0 {
                // calculting date difference between current date and scheduled date
                if let dateString = dateFormatter2.date(from: myClassDetails[indexPath.row - 1]?.scheduleDate ?? ""){
                    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: dateString)
                    let difference = Calendar.current.dateComponents([.day], from: today, to: tomorrow!)
                    guard let days = difference.day else { return }
                    let ess = days > 1 ? "s" : ""
                    print("That date is \(days) day\(ess) away.")
                    if Int(days) >= 0{
                        
                        // get time differnce between current time and start time and end time of scheduled time
                        if let th = todayTimeHour, let tm = todayTimeMin{
                            print("..th...\(th)")
                            print("..tm...\(tm)")
                            print("..timeslot...\(myClassDetails[indexPath.row - 1]?.timeSlotFrom)")
                            // time difference of start class and current time
                            let timeDiff = findDateDiff(time1Str: "\(th):\(tm)", time2Str: myClassDetails[indexPath.row -  1]?.timeSlotFrom ?? "12:00")
                            // time difference of end time and current time
                            let timeDiffEnd = findDateDiff(time1Str: "\(th):\(tm)", time2Str: myClassDetails[indexPath.row -  1]?.timeSlotTo ?? "12:00")
                            print("..diff...\(timeDiffEnd)")
                            print("..diff...\(Int(days))")
                            
                            
                            
                            // check today's class time has finished , if finished dont navigate or navigate
                            if timeDiffEnd < 0 && Int(days) <= 0{
                                print("ended class")
                            }else{
                                let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "MyClassesDetailsViewController") as? MyClassesDetailsViewController
                                vc!.classStatus = myClassDetails[indexPath.row - 1]?.status ?? ""
                                vc!.daysLeft = Int(days)
                                vc!.scheduledClassInfo = scheduledClassInfo[3]
                                // check demo class
                                
                                StructOperation.glovalVariable.isDemo = myClassDetails[indexPath.row - 1]?.is_demo ?? ""
                                //check demo class ends
                                if let facultyName = myClassDetails[indexPath.row - 1]?.faculty?.name{
                                    vc?.facultyName = facultyName
                                }
                                
                                // faculty profile starts
                                if let img = myClassDetails[indexPath.row - 1]?.faculty?.facultyPic.image_url{
                                    
                                    vc?.profilePic = img
                                }
                                
                                //faculty profile ends
                                // time difference
                                dateFormatter.dateFormat = "HH:mm"
                                let from = dateFormatter.date(from: myClassDetails[indexPath.row - 1]?.timeSlotFrom ?? "")
                                let to = dateFormatter.date(from: myClassDetails[indexPath.row - 1]?.timeSlotTo ?? "")
                                let diff = Int(to!.timeIntervalSince1970 - from!.timeIntervalSince1970)
                                let hours = diff / 3600
                                print("time 1....\(from)")
                                print("time 2....\(to)")
                                print("time difference....\(hours)")
                                // time difference ends
                                if hours < 0{
                                   StructOperation.glovalVariable.timeDifference = String(24 + hours)
                                }else{
                                    StructOperation.glovalVariable.timeDifference = String(hours)
                                }
                                
                                vc?.classId = myClassDetails[indexPath.row - 1]?._id ?? ""
                                //vc?.daysleft = "\(days)"
                                vc?.subject = myClassDetails[indexPath.row - 1]?.subject[0].subjectName ?? ""
                                vc?.scheduledate = myClassDetails[indexPath.row - 1]?.scheduleDate ?? ""
                                vc?.scheduleTime = myClassDetails[indexPath.row - 1]?.timeSlotFrom ?? ""
                                vc?.classType = myClassDetails[indexPath.row - 1]?.classType ?? ""
                                //print("stuid..\(myClassDetails[indexPath.row - 1]?.student?._id)")
                                if let stuId = myClassDetails[indexPath.row - 1]?.student?._id{
                                    StructOperation.glovalVariable.studentId = stuId
                                    print("stuid..\(StructOperation.glovalVariable.studentId)")
                                }
                                // subject name
                                StructOperation.glovalVariable.forRescheduleSubjectName = myClassDetails[indexPath.row - 1]?.subject[0].subjectName ?? ""
                                // get classid
                                StructOperation.glovalVariable.classId = myClassDetails[indexPath.row - 1]?._id ?? "1"
                                
                                //check faculty has two different fare for online and offline
                                if myClassDetails[indexPath.row - 1]?.faculty?.subjects[0].hourlyCompensation.count ?? 1 > 1{
                                    if myClassDetails[indexPath.row - 1]?.classType == "2"{
                                                                     if let fCharge = myClassDetails[indexPath.row - 1]?.faculty?.subjects[0].hourlyCompensation[0].facultyCharges{
                                                                         StructOperation.glovalVariable.hourlyCompenstaion = fCharge
                                                                     }
                                                                     
                                                                 }else{
                                                                     if let fCharge = myClassDetails[indexPath.row - 1]?.faculty?.subjects[0].hourlyCompensation[1].facultyCharges{
                                                                         StructOperation.glovalVariable.hourlyCompenstaion = fCharge
                                                                     }
                                                                     
                                                                     
                                                                 }
                                    
                                }else{
                                    if let fCharge = myClassDetails[indexPath.row - 1]?.faculty?.subjects[0].hourlyCompensation[0].facultyCharges{
                                                                                                          StructOperation.glovalVariable.hourlyCompenstaion = fCharge
                                                                                                      }
                                }
                             
                                if let fname = myClassDetails[indexPath.row - 1]?.faculty?.name{
                                    StructOperation.glovalVariable.facultyName = fname
                                    
                                }
                                // languages
                                if let langKnowns = myClassDetails[indexPath.row - 1]?.faculty?.languagesKnown{
                                    StructOperation.glovalVariable.languageKnowns = langKnowns
                                }
                                print("lang...\(StructOperation.glovalVariable.languageKnowns)")
                                //subject id
                                if let subId = myClassDetails[indexPath.row - 1]?.subject[0]._id{
                                    StructOperation.glovalVariable.subjectId = subId
                                }
                                
                                //faculty id
                                if let facId = myClassDetails[indexPath.row - 1]?.faculty?._id{
                                    StructOperation.glovalVariable.facultyId = facId
                                }
                                
                                vc!.hidesBottomBarWhenPushed = true
                                self.navigationController?.pushViewController(vc!, animated: false)
                            }
                            
                        }
                        
                        
                    }else{
                        
                        print("old class")
                        if myClassDetails[indexPath.row - 1]?.status == "completed" && myClassDetails[indexPath.row - 1]?.faculty?.ratings == ""{
                            print("completed")
                            let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "MyClassesDetailsViewController") as? MyClassesDetailsViewController
                            vc!.hidesBottomBarWhenPushed = true
                            vc!.ratingViewBottom.constant = 0
                            //faculty id
                            if let facId = myClassDetails[indexPath.row - 1]?.faculty?._id{
                                StructOperation.glovalVariable.facultyId = facId
                            }
                            self.navigationController?.pushViewController(vc!, animated: false)
                        }
                    }
                }
            }else{
                
                print("old class")
            }
            
        }
    }
    
}

extension MyClassesViewController{
    func getDayOfWeek(_ today:String) -> String? {
        let df  = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        let date = df.date(from: today)!
        df.dateFormat = "EEEE"
        return df.string(from: date);
    }
    
}
extension Date {
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
}
extension MyClassesViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
}
extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}
