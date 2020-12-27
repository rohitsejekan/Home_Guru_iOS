//
//  ScheduleNonAcademicListViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 20/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ScheduleNonAcademicListViewController:UIViewController, IndicatorInfoProvider,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var nonAcademicSubjectList : [[String:Any]] = [["title":"Sports"],["title":"Drawing"],["title":"Craft"],["title":"Extra"],["title":"Curiculums"]]
    var childNumber = ""
    var index : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 66.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "ScheduleSubjectTableViewCell", bundle: nil), forCellReuseIdentifier: "ScheduleSubjectTableViewCell")
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(childNumber)")
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nonAcademicSubjectList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleSubjectTableViewCell", for: indexPath) as? ScheduleSubjectTableViewCell
        cell?.subjectLabel.text = nonAcademicSubjectList[indexPath.row]["title"] as! String
        cell?.radioImageView.image = UIImage(named: indexPath.row == index ? "radioSelected" : "radioUnselected")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
