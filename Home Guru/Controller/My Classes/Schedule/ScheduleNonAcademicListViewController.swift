//
//  ScheduleNonAcademicListViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 20/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
///Users/priya/Desktop/Home_Guru_iOS/Home Guru/Controller/My Classes/Schedule/ScheduleNonAcademicListViewController.swift

import UIKit
import XLPagerTabStrip
import SwiftyJSON
import NVActivityIndicatorView
class ScheduleNonAcademicListViewController:UIViewController, IndicatorInfoProvider,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var activityLoaderView: NVActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
     var getNonAcademicDetails = [NonAcademic]()
    var nonAcademicDetails: [String: String] = [:]
    var nonAcademicSubjectList : [[String:Any]] = [["title":"Sports"],["title":"Drawing"],["title":"Craft"],["title":"Extra"],["title":"Curiculums"]]
    var childNumber = ""
    var index : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 66.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "ScheduleSubjectTableViewCell", bundle: nil), forCellReuseIdentifier: "ScheduleSubjectTableViewCell")
        getNonAcademic()
    }
    
    private func getNonAcademic(){
        activityLoaderView.startAnimating()
        nonAcademicDetails["programType"] = "nonacademic"
         //        parentDetails["mobileNo"] = UserDefaults.standard.string(forKey: Constants.mobileNo)
                 AlamofireService.alamofireService.postRequestWithBodyData(url: URLManager.sharedUrlManager.groupCategory, details: nonAcademicDetails) {
                 response in
                    switch response.result {
                    case .success(let value):
                        if let status =  response.response?.statusCode {
                        print("status is ..\(status)")
                         print("value...\(value)")
                            if status == 200 || status == 201 {
                         let val = JSON(value)
                             for arr in val.arrayValue{
                                
                                self.getNonAcademicDetails.append(NonAcademic(json: arr))
                             }
                         
                                                   
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
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(childNumber)")
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNonAcademicDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleSubjectTableViewCell", for: indexPath) as? ScheduleSubjectTableViewCell
        cell?.subjectLabel.text = getNonAcademicDetails[indexPath.row].groupName
//        cell?.radioImageView.image = UIImage(named: indexPath.row == index ? "radioSelected" : "radioUnselected")
        cell?.radioImageView.image = UIImage(named: "Vector")
        cell?.selectionStyle = .none
        cell?.preservesSuperviewLayoutMargins = false
        cell?.separatorInset = .zero
        cell?.layoutMargins = .zero
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "ScheduleAcademicList_2") as! ScheduleAcademicList_2ViewController
        //setNavigationBackTitle(title: "Schedule")
        vc.hidesBottomBarWhenPushed = true
        vc.groupId = getNonAcademicDetails[indexPath.row]._id
//         presentDetail(vc)
         self.navigationController?.pushViewController(vc, animated: false)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
