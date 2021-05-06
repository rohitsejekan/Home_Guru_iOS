//
//  ScheduleAcademicListViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 20/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class ScheduleAcademicListViewController: UIViewController, IndicatorInfoProvider,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var academicSubjectList : [[String:Any]] = [["title":"English"],["title":"Hindi"],["title":"Maths"],["title":"Kannada"],["title":"Science"],["title":"Social Science"],["title":"Physics"],["title":"Chemistry"],["title":"Biology"],["title":"Biotechnology"]]
    var childNumber = ""
    var index : Int = 0
    
    @IBOutlet weak var activityLoaderView: NVActivityIndicatorView!
    var academicDetails: [String: String] = [:]
    var getAcademic = [AcademicService]()
    override func viewDidLoad() {
        super.viewDidLoad()
      
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "ScheduleSubjectTableViewCell", bundle: nil), forCellReuseIdentifier: "ScheduleSubjectTableViewCell")
        activityLoaderView.startAnimating()
                academicDetails["programType"] = "academic"
        //        parentDetails["mobileNo"] = UserDefaults.standard.string(forKey: Constants.mobileNo)
                AlamofireService.alamofireService.postRequestWithBodyData(url: URLManager.sharedUrlManager.groupCategory, details: academicDetails) {
                response in
                   switch response.result {
                   case .success(let value):
                       if let status =  response.response?.statusCode {
                       print("status is ..\(status)")
                        print("value...\(value)")
                           if status == 200 || status == 201 {
                        let val = JSON(value)
                            for arr in val.arrayValue{
                               
                                self.getAcademic.append(AcademicService(json: arr))
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
    deinit {
        print("ViewController deinit")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(childNumber)")
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getAcademic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleSubjectTableViewCell", for: indexPath) as? ScheduleSubjectTableViewCell
        cell?.subjectLabel.text = getAcademic[indexPath.row].groupName
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
        vc.navName = getAcademic[indexPath.row].groupName
               //setNavigationBackTitle(title: "Schedule")
               vc.hidesBottomBarWhenPushed = true
        print("gid...\(getAcademic[indexPath.row]._id)")
        vc.groupId = getAcademic[indexPath.row]._id
        self.navigationController?.pushViewController(vc, animated: false)

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
