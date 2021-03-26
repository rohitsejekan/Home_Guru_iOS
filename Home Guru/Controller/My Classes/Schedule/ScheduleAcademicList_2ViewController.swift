//
//  ScheduleAcademicList_2ViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 11/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import SwiftyJSON
class ScheduleAcademicList_2ViewController: UIViewController, IndicatorInfoProvider,UITableViewDataSource, UITableViewDelegate{
    
    
    var groupId: String = ""
    var groupDetails: [String: String] = [:]
    var childGroupDetails = [AcademicGroup]()
    @IBOutlet weak var backBtn: UIButton!
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(childNumber)")
    }
    
    
 
    @IBOutlet weak var tableView: UITableView!
    var academicSubjectList : [[String:Any]] = [["title":"Class 1-12"],["title":"others"]]
       var childNumber = ""
       var index : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ScheduleSubject_2TableViewCell", bundle: nil), forCellReuseIdentifier: "ScheduleSubject_2")
        backBtn.layer.cornerRadius = 5
        getGroupCat()
    }
    func getGroupCat(){
                groupDetails["categoryid"] = groupId
        //        parentDetails["mobileNo"] = UserDefaults.standard.string(forKey: Constants.mobileNo)
                AlamofireService.alamofireService.postRequestWithBodyData(url: URLManager.sharedUrlManager.groupChildCategory, details: groupDetails) {
                response in
                   switch response.result {
                   case .success(let value):
                       if let status =  response.response?.statusCode {
                       print("status is ..\(status)")
                        print("value...\(value)")
                           if status == 200 || status == 201 {
                        let val = JSON(value)
                            for arr in val.arrayValue{
                               
                                print("child...\(arr)")
                                self.childGroupDetails.append(AcademicGroup(json: arr))
                            }
                        
                                                  
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

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return childGroupDetails.count
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 75
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleSubject_2", for: indexPath) as? ScheduleSubject_2TableViewCell
            cell?.sub_2Name.text = childGroupDetails[indexPath.row].groupName
            cell?.selectionStyle = .none
            cell?.preservesSuperviewLayoutMargins = false
                  cell?.separatorInset = .zero
                  cell?.layoutMargins = .zero
    //        cell?.radioImageView.image = UIImage(named: indexPath.row == index ? "radioSelected" : "radioUnselected")
          
            return cell!
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            index = indexPath.row
            if childGroupDetails[indexPath.row].has_board == "0"{
                let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "ScheduleAcademicList_3") as! ScheduleAcademicList_3ViewController
                                 //setNavigationBackTitle(title: "Schedule")
                                 vc.hidesBottomBarWhenPushed = true
                      vc.groupId = childGroupDetails[indexPath.row]._id
                      self.navigationController?.pushViewController(vc, animated: false)

                      DispatchQueue.main.async {
                          self.tableView.reloadData()
                      }
            }else{
                let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "ScheduleAcademicList_5ViewController") as! ScheduleAcademicList_5ViewController
                                       //setNavigationBackTitle(title: "Schedule")
                                       vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: false)
            }
      
        }
    @IBAction func goBack(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}
