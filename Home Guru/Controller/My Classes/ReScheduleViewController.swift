//
//  ReScheduleViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 08/04/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit
class ReScheduleViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource{
 

    @IBOutlet weak var pickerViewStart: UIDatePicker!
    
    var boards: [String] = ["class 1","class 10","class 1","class 1","class 1"]
     var startDuration: [String] = ["1 Hour","2 Hour","4 Hour","6 Hour","8 Hour"]
    var scheduleDetails : [String:String] = ["classType" : "Online Class","timings":"select","weeks":"2 weeks"]
    var selectedTime: String = ""
    var timeSlot: String = "select time"
    var timeTruncate: String = ""
    
    @IBOutlet weak var outerPickerStartView: UIView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
        
        //convert datepicker to time picker
        pickerViewStart.datePickerMode = .time
        // make timer quater based
        pickerViewStart.minuteInterval = 30
        outerPickerStartView.isHidden = true
    }
    
    @IBAction func dismissPV1(_ sender: UIBarButtonItem) {
//        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
//               hideUnhidePickerView(view: self.outerPickerDurationView, value: true)
//        reload(tableView: self.tableView)
//        print("clicked")
    }
    @IBAction func dismissPV2(_ sender: UIBarButtonItem) {
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
               hideUnhidePickerView(view: self.outerPickerStartView, value: true)
        reload(tableView: self.tableView)
    }
    func reload(tableView: UITableView) {

           let contentOffset = tableView.contentOffset
           tableView.reloadData()
           tableView.layoutIfNeeded()
           tableView.setContentOffset(contentOffset, animated: false)

       }
    @IBAction func selectDays(_ sender: UIButton) {
//        if outerPickerDurationView.isHidden{
//                  outerPickerDurationView.isHidden = false
//              }
    }
    @IBAction func selectTime(_ sender: UIButton) {
        
        timeTruncate = String(pickerViewStart.date.string1(format: "HH:mm"))
       
        timeSlot = timeTruncate
        StructOperation.glovalVariable.reScheduleTimeSlotFrom = timeTruncate
        if outerPickerStartView.isHidden{
            outerPickerStartView.isHidden = false
        }
    }
  
 

      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 1
     }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "ReSchedule") as! ReScheduleTableViewCell
        cell.goNextPage.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        cell.startTime.setTitle(timeSlot, for: .normal)
       cell.classDuration.setTitle(StructOperation.glovalVariable.timeDifference + " hr", for: .normal)
        
        cell.atHome.setTitleColor((scheduleDetails["classType"] == "Online Class") ? ColorPalette.whiteColor : ColorPalette.homeGuruOrangeColor, for: .normal)
        cell.atHome.setImage(UIImage(named:(scheduleDetails["classType"] == "Online Class") ?  "whiteAtHome" : "orangeHome") , for: .normal)
        cell.onlineClasses.setTitleColor((scheduleDetails["classType"] == "Online Class") ? ColorPalette.homeGuruOrangeColor : ColorPalette.whiteColor, for: .normal)
        cell.onlineClasses.setImage(UIImage(named: (scheduleDetails["classType"] == "Online Class") ? "orangeVideoClass" : "onlineWhite"), for: .normal)

        cell.goNextPage.tag = indexPath.row
        cell.selectionStyle = .none

         return cell
     }
    @IBAction func chooseClassTypeAction(_ sender: UIButton) {
         scheduleDetails["classType"] = sender.tag == 0 ? "At Home" : "Online Class"
         if sender.tag == 0{
             UserDefaults.standard.set("1", forKey: "classType")
             print("retrive 1....\(UserDefaults.standard.string(forKey: "classType"))")
         }else{
             UserDefaults.standard.set("2", forKey: "classType")
               print("retrive 2....\(UserDefaults.standard.string(forKey: "classType"))")
         }
         self.tableView.reloadData()
     }
    @objc func connected(sender: UIButton){
//        let buttonTag = sender.tag
           let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "SelectSchedule") as! SelectScheduleViewController
           //setNavigationBackTitle(title: "Schedule")
           vc.hidesBottomBarWhenPushed = true
           vc.reSchedule = true
        
           self.navigationController?.pushViewController(vc, animated: false)

    }
    @IBAction func goBaack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension Date {
    var localTime1: String {
        return description(with: NSLocale.current)
    }
}
extension Date {
    func localDate1() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}

        return localDate
    }
}
extension Date {
    func string1(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
