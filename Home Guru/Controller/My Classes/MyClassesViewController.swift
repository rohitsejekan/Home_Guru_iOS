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

class MyClassesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource,refreshProtocol {
    // refresh tableview
    func refreshTableView() {
        getMyclassDetails()
    }
    
    @IBOutlet weak var activityLoaderView: NVActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    var overlayBool: Bool = false
    var myClassDetails = [myClasses?]()
    var points : Int = 0
    var refreshDelegate: MyClassesDetailsViewController?
    var scheduledClassInfo : [[String:Any]] = [["classType":"old class","dateObj":Date()],["classType":"today","dateObj":Date()],["classType":"not held","dateObj":Date()],["classType":"future", "dateObj":Date()],["classType":"future demo","dateObj":Date()]]
    var classDetails : [Int] = []
    var showData : Bool = false
    var dateString: String = ""
    let today = Date()
    var vSpinner : UIView?
    var dataDisplayType : DataDisplayType = .registerInfo
    //date formatter
    let dateFormatter = DateFormatter()
    //activity indicator
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
   fileprivate lazy var dateFormatter2: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd"
          return formatter
      }()
    override func viewDidLoad() {
        super.viewDidLoad()
        //refresh tableview based on call from previous vc
        refreshDelegate?.refreshDelegate = self
        //refresh tableview based on call from previous vc ends
        //token
        print("token...\(UserDefaults.standard.string(forKey: Constants.token))")
        //navigationController?.hidesBarsOnTap = true
        tableView.estimatedRowHeight = 400.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "ScheduledClassCardTableViewCell", bundle: nil), forCellReuseIdentifier: "ScheduledClassCardTableViewCell")
        navigationController?.delegate = self
        getMyclassDetails()
        
        print("today....\(dateString)")
        let tomorrow = Date().dayAfter
        //Calculate the number of days between today and the user's chosen day.
        let difference = Calendar.current.dateComponents([.day], from: today, to: tomorrow)
        guard let days = difference.day else { return }
        let ess = days > 1 ? "s" : ""
        print("That date is \(days) day\(ess) away.")


      //  let components = cal.dateComponents(.Day, from: startDate, to: endDate, options: [])

       // print("dates...\(components)")
        
    }
    
  //refresh tableview
     @objc func refresh() {

        self.tableView.reloadData() // a refresh the tableView.

    }
    //refresh tableview
    func getMyclassDetails(){
        activityLoaderView.startAnimating()
            AlamofireService.alamofireService.getRequestWithToken(url: URLManager.sharedUrlManager.getMyClasses + "studentId=\(2)", parameters: nil) {
                            response in
                               switch response.result {
                               case .success(let value):
                                   if let status =  response.response?.statusCode {
                                   print("guru p ..\(status)")
                                    print("g p...\(value)")
                                       if status == 200 || status == 201 {
                                    let val = JSON(value)
                                        for arr in val.arrayValue{
                                           
                                            if arr["status"].stringValue == "cancelled"{
                                                continue
                                            }
                                         print("ststus...\(arr["status"].stringValue)")
                                         self.myClassDetails.append(myClasses(json: arr))
                                           // print("child sub...\(arr)")
           
                                        }
                                        print("classes.......\(self.myClassDetails)")
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          hideNavbar()
        print("stu id...\(StructOperation.glovalVariable.studentId)")
        self.navigationController?.navigationBar.frame = CGRect(x: 0,y: 0,width: 0,height: 0);
               //        if UserDefaults.standard.bool(forKey: Constants.isRegistered) {
//            getScheduledClassInfo()
//        } else {
            self.dataDisplayType = .scheduleInfo
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
        case "REGISTER":
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
        cell?.actionBtn.layer.cornerRadius = 0
        cell?.selectionStyle = .none
       // cell?.bgImage.image = imageWithGradient(img:cell?.bgImage.image!)
        if overlayBool == false{
            cell!.overlayView.backgroundColor = ColorPalette.homeGuruBlueColor.withAlphaComponent(0.9)
            overlayBool = true
        }
        
      
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dataDisplayType == .homeInfo || dataDisplayType == .registerInfo {
            if indexPath.row == 0{
               tableView.isScrollEnabled = false
                return tableView.frame.height
            }
            
        }else{
             tableView.isScrollEnabled = true
        }
        return UITableView.automaticDimension
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
                        cell?.classImageView.image = UIImage(named: "orangeVideoClass")
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
                let difference = Calendar.current.dateComponents([.day], from: today, to: dateString)
                guard let days = difference.day else { return cell! }
                let ess = days > 1 ? "s" : ""
                print("That date is \(days) day\(ess) away.")
                
                    
                if Int(days) < 0{
                    if myClassDetails[indexPath.row - 1]?.status == "completed"{
                       cell?.setCardValues(data: scheduledClassInfo[0])
                        cell?.noOfDaysLeft.text = "class completed!"
                    }
                    if myClassDetails[indexPath.row - 1]?.status == "upcoming"{
                        cell?.setCardValues(data: scheduledClassInfo[1])
                        cell?.noOfDaysLeft.text = "class not held!"
                    }
                    
                }else{
                    // set date left
                    if days == 0{
                        cell?.noOfDaysLeft.text = "Today"
                    }else{
                        cell?.noOfDaysLeft.text = "\(days)" + " days left"
                    }
                    // set date left ends
                    
                    // change card color based on demo
                    if myClassDetails[indexPath.row - 1]?.is_demo == "1"{
                        cell?.setCardValues(data: scheduledClassInfo[3])
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
                    let difference = Calendar.current.dateComponents([.day], from: today, to: dateString)
                        guard let days = difference.day else { return }
                    let ess = days > 1 ? "s" : ""
                    print("That date is \(days) day\(ess) away.")
                    if Int(days) >= 0{
                        let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "MyClassesDetailsViewController") as? MyClassesDetailsViewController
                        vc!.classStatus = myClassDetails[indexPath.row - 1]?.status as! String
                            vc!.scheduledClassInfo = scheduledClassInfo[3]
                        // check demo class
                        StructOperation.glovalVariable.isDemo = myClassDetails[0]?.is_demo as! String
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
                        
                        StructOperation.glovalVariable.timeDifference = String(hours)
                        vc?.classId = myClassDetails[indexPath.row - 1]?._id as! String
                        vc?.daysleft = "\(days)"
                        vc?.subject = myClassDetails[indexPath.row - 1]?.subject[0].subjectName as! String
                        vc?.scheduledate = myClassDetails[indexPath.row - 1]?.scheduleDate as! String
                        vc?.scheduleTime = myClassDetails[indexPath.row - 1]?.timeSlotFrom as! String
                        vc?.classType = myClassDetails[indexPath.row - 1]?.classType as! String
                        print("stuid..\(myClassDetails[indexPath.row - 1]?.student?._id)")
                        if let stuId = myClassDetails[indexPath.row - 1]?.student?._id{
                                StructOperation.glovalVariable.studentId = stuId
                                print("stuid..\(StructOperation.glovalVariable.studentId)")
                            }
                        // subject name
                        StructOperation.glovalVariable.forRescheduleSubjectName = myClassDetails[indexPath.row - 1]?.subject[0].subjectName as! String
                        // get classid
                        StructOperation.glovalVariable.classId = myClassDetails[indexPath.row - 1]?._id as! String
                   
                        if myClassDetails[indexPath.row - 1]?.classType == "2"{
                                if let fCharge = myClassDetails[indexPath.row - 1]?.faculty?.subjects[0].hourlyCompensation[0].facultyCharges{
                                    StructOperation.glovalVariable.hourlyCompenstaion = fCharge
                                }
                                
                            }else{
                            if let fCharge = myClassDetails[indexPath.row - 1]?.faculty?.subjects[0].hourlyCompensation[1].facultyCharges{
                                    StructOperation.glovalVariable.hourlyCompenstaion = fCharge
                                }
                                

                            }
                        if let fname = myClassDetails[indexPath.row - 1]?.faculty?.name{
                            StructOperation.glovalVariable.facultyName = fname
                            
                        }
                        if let langKnowns = myClassDetails[indexPath.row - 1]?.faculty?.languagesKnown{
                            StructOperation.glovalVariable.languageKnowns = langKnowns
                        }
                        
                        StructOperation.glovalVariable.subjectId = myClassDetails[indexPath.row - 1]?.subject[0]._id as! String
                           
                        if let facId = myClassDetails[indexPath.row - 1]?.faculty?._id{
                                StructOperation.glovalVariable.facultyId = facId
                            }
                            
                            vc!.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(vc!, animated: false)
                        }else{
                        
                              print("old class")
                        if myClassDetails[indexPath.row - 1]?.status == "completed"{
                                        print("completed")
                                        let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "MyClassesDetailsViewController") as? MyClassesDetailsViewController
                                        vc!.hidesBottomBarWhenPushed = true
                                        vc!.ratingViewBottom.constant = 0
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
