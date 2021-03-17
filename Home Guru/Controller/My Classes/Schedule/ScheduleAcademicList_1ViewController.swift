//
//  ScheduleAcademicListViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 20/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ScheduleAcademicList_1ViewController: UIViewController, IndicatorInfoProvider,UITableViewDataSource, UITableViewDelegate {

 var academicSubjectList : [[String:Any]] = [["title":"Class 1-12"],["title":"others"]]
    var childNumber = ""
    var index : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.register(UINib(nibName: "ScheduleSubjectTableViewCell", bundle: nil), forCellReuseIdentifier: "ScheduleSubjectTableViewCell")
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
        return academicSubjectList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleSubjectTableViewCell", for: indexPath) as? ScheduleSubjectTableViewCell
        cell?.subjectLabel.text = academicSubjectList[indexPath.row]["title"] as? String
//        cell?.radioImageView.image = UIImage(named: indexPath.row == index ? "radioSelected" : "radioUnselected")
        cell?.radioImageView.image = UIImage(named: "dropDown")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
