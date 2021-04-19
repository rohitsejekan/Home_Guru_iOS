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
enum DataDisplayType {
    case homeInfo, scheduleInfo, registerInfo
}

class MyClassesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var overlayBool: Bool = false
    var myClassDetails = [myClasses]()
    var points : Int = 0
    var scheduledClassInfo : [[String:Any]] = [["classType":"old class","dateObj":Date()],["classType":"today","dateObj":Date()],["classType":"demo today","dateObj":Date()],["classType":"future", "dateObj":Date()],["classType":"future demo","dateObj":Date()]]
    var classDetails : [Int] = []
    var showData : Bool = false
    var dateString: String = ""
    var dataDisplayType : DataDisplayType = .registerInfo
   fileprivate lazy var dateFormatter2: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd"
          return formatter
      }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationController?.hidesBarsOnTap = true
        tableView.estimatedRowHeight = 400.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "ScheduledClassCardTableViewCell", bundle: nil), forCellReuseIdentifier: "ScheduledClassCardTableViewCell")
        navigationController?.delegate = self
        getMyclassDetails()
        let date = Date()
        dateString = dateFormatter2.string(from: date)
        print("today....\(dateString)")
        
     let start = "2010-09-01"
        let end = "2010-09-05"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

       



      //  let components = cal.dateComponents(.Day, from: startDate, to: endDate, options: [])

       // print("dates...\(components)")
        
    }
  
    func getMyclassDetails(){
               
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
                                         self.myClassDetails.append(myClasses(json: arr))
                                           // print("child sub...\(arr)")
                    
                    
                                        }
                                        print("classes.......\(self.myClassDetails)")
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          hideNavbar()
        self.navigationController?.navigationBar.frame = CGRect(x: 0,y: 0,width: 0,height: 0);
               //        if UserDefaults.standard.bool(forKey: Constants.isRegistered) {
//            getScheduledClassInfo()
//        } else {
            self.dataDisplayType = .registerInfo
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
            cell?.moduleLabel.text = myClassDetails[indexPath.row - 1].subject[0].subjectName
            cell?.nameLabel.text = myClassDetails[indexPath.row - 1].faculty?.name
            cell?.dateLabel.text = myClassDetails[indexPath.row - 1].scheduleDate
            cell?.timeLabel.text = myClassDetails[indexPath.row - 1].timeSlotFrom
             if let weekday = getDayOfWeek(myClassDetails[indexPath.row - 1].scheduleDate) {
                           cell?.dayLabel.text = String(weekday.prefix(3))
            } else {
                print("bad input")
                }
            cell?.setCardValues(data: scheduledClassInfo[indexPath.row - 1])
            cell?.selectionStyle = .none
            return cell!
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataDisplayType == .scheduleInfo {
            if indexPath.row != 0 {
                let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "MyClassesDetailsViewController") as? MyClassesDetailsViewController
               // setNavigationBackTitle(title: getDateString(format: "dd MMM yyyy (E)", date: scheduledClassInfo[indexPath.row]["dateObj"] as! Date))
                vc!.scheduledClassInfo = scheduledClassInfo[indexPath.row - 1]
                if let facultyName = myClassDetails[indexPath.row - 1].faculty?.name{
                    vc?.facultyName = facultyName
                }
                vc?.classId = myClassDetails[indexPath.row - 1]._id
                vc?.subject = myClassDetails[indexPath.row - 1].subject[0].subjectName
                vc?.scheduledate = myClassDetails[indexPath.row - 1].scheduleDate
                vc?.scheduleTime = myClassDetails[indexPath.row - 1].timeSlotFrom
                vc?.classType = myClassDetails[indexPath.row - 1].classType
                if let stuId = myClassDetails[indexPath.row - 1].student?._id{
                    StructOperation.glovalVariable.studentId = stuId
                }
                if myClassDetails[indexPath.row - 1].classType == "2"{
                    if let fCharge = myClassDetails[indexPath.row - 1].faculty?.subjects[0].hourlyCompensation[0].facultyCharges{
                        StructOperation.glovalVariable.hourlyCompenstaion = fCharge
                    }
                    
                }else{
                    if let fCharge = myClassDetails[indexPath.row - 1].faculty?.subjects[0].hourlyCompensation[1].facultyCharges{
                        StructOperation.glovalVariable.hourlyCompenstaion = fCharge
                    }
                    

                }
                    StructOperation.glovalVariable.subjectId = myClassDetails[indexPath.row - 1].subject[0]._id
               
                if let facId = myClassDetails[indexPath.row - 1].faculty?._id{
                    StructOperation.glovalVariable.facultyId = facId
                }
                
                vc!.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc!, animated: false)
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
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
