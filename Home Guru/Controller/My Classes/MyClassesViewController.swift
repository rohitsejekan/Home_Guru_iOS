//
//  MyClassesViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 03/12/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import MBProgressHUD

enum DataDisplayType {
    case homeInfo, scheduleInfo, registerInfo
}

class MyClassesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var points : Int = 0
    var scheduledClassInfo : [[String:Any]] = [["classType":"old class","dateObj":Date()],["classType":"today","dateObj":Date()],["classType":"demo today","dateObj":Date()],["classType":"future", "dateObj":Date()],["classType":"future demo","dateObj":Date()]]
    var classDetails : [Int] = []
    var showData : Bool = false
    var dataDisplayType : DataDisplayType = .homeInfo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavbar()
        tableView.estimatedRowHeight = 400.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "ScheduledClassCardTableViewCell", bundle: nil), forCellReuseIdentifier: "ScheduledClassCardTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        if UserDefaults.standard.bool(forKey: Constants.isRegistered) {
//            getScheduledClassInfo()
//        } else {
            self.dataDisplayType = .registerInfo
            reloadData()
//        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.showData = true
            self.tableView.reloadData()
        }
    }
    
    @IBAction func bookClassAction(_ sender: UIButton) {
        let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "ScheduleViewController") as? ScheduleViewController
        setNavigationBackTitle(title: "Schedule")
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        switch sender.currentTitle {
        case "REGISTER":
//            let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "RegisterParentViewController") as? RegisterParentViewController
//            setNavigationBackTitle(title: "Register")
//            vc!.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc!, animated: false)
            let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "ScheduleViewController") as? ScheduleViewController
            setNavigationBackTitle(title: "Schedule")
            vc!.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc!, animated: false)
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
        return showData ? ((dataDisplayType == .homeInfo || dataDisplayType == .registerInfo) ? 1 : (( scheduledClassInfo.count == 0 ? 1 : scheduledClassInfo.count + 1))) : 0
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
        cell?.selectionStyle = .none
        return cell!
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
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduledClassCardTableViewCell", for: indexPath) as? ScheduledClassCardTableViewCell
        cell?.setCardValues(data: scheduledClassInfo[indexPath.row-1])
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataDisplayType == .scheduleInfo {
            if indexPath.row != 0 {
                let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "MyClassesDetailsViewController") as? MyClassesDetailsViewController
                setNavigationBackTitle(title: getDateString(format: "dd MMM yyyy (E)", date: scheduledClassInfo[indexPath.row]["dateObj"] as! Date))
                vc!.scheduledClassInfo = scheduledClassInfo[indexPath.row]
                vc!.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc!, animated: false)
            }
        }
    }
    
}
