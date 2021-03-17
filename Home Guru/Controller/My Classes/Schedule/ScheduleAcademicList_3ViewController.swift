//
//  ScheduleAcademicList_3ViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 12/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ScheduleAcademicList_3ViewController: UIViewController,IndicatorInfoProvider,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    var academicSubjectList : [[String:Any]] = [["title":"Class 1"],["title":"Class 2"],["title":"Class 3"],["title":"Class 4"],["title":"Class 5"],["title":"Class 6"],["title":"Class 7"],["title":"Class 8"]]
         var childNumber = ""
         var index : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
         tableView.register(UINib(nibName: "ScheduleSubject_2TableViewCell", bundle: nil), forCellReuseIdentifier: "ScheduleSubject_2")
        
        backBtn.layer.cornerRadius = 5
    }
    

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
          return IndicatorInfo(title: "\(childNumber)")
      }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return academicSubjectList.count
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 75
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleSubject_2", for: indexPath) as? ScheduleSubject_2TableViewCell
           cell?.sub_2Name.text = academicSubjectList[indexPath.row]["title"] as? String
            cell?.selectionStyle = .none
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = .zero
            cell?.layoutMargins = .zero
    //        cell?.radioImageView.image = UIImage(named: indexPath.row == index ? "radioSelected" : "radioUnselected")
          
            return cell!
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            index = indexPath.row
            let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "ScheduleAcademicList_4") as! ScheduleAcademicList_4ViewController
                               //setNavigationBackTitle(title: "Schedule")
                               vc.hidesBottomBarWhenPushed = true
                              presentDetail(vc)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}