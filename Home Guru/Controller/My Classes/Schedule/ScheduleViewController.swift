//
//  ScheduleViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 20/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit

enum PickerType {
    case timings, weeks
}

class ScheduleViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, ProgramPickerProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    var programPickerView : ProgramPickerView?
    var weeksList : [String] = ["2 weeks","3 weeks","4 weeks"]
    var timingsList : [String] = ["09.00 am - 10.00 am","11.00 am - 12.00 pm","01.00 pm - 02.00 pm"]
    var pickerType : PickerType = .timings
    var scheduleDetails : [String:String] = ["classType" : "Online Class","timings":"09.00 am - 10.00 am","weeks":"2 weeks"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 498.0
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func chooseClassTypeAction(_ sender: UIButton) {
        scheduleDetails["classType"] = sender.tag == 0 ? "At Home" : "Online Class"
        self.tableView.reloadData()
    }
    
    @IBAction func chooseTimingsAction(_ sender: UIButton) {
        showProgramPicker(pickerType: .timings)
    }
    
    @IBAction func noOfWeeksAction(_ sender: UIButton) {
        showProgramPicker(pickerType: .weeks)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "ScheduleSubjectViewController") as? ScheduleSubjectViewController
        setNavigationBackTitle(title: "Select Subject")
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    func showProgramPicker(pickerType: PickerType) {
        self.pickerType = pickerType
        programPickerView = Bundle.main.loadNibNamed("ProgramPickerView", owner: self, options: nil)?.first as! ProgramPickerView
        programPickerView?.delegate = self
        programPickerView?.programList = (pickerType == .timings) ? timingsList : weeksList
        programPickerView?.showProgramPickerView(onView: self.tableView)
        tableView.isScrollEnabled = false
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.none, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as? ScheduleTableViewCell
        cell?.timingsBtn.setTitle(scheduleDetails["timings"], for: .normal)
        cell?.noOfWeeksBtn.setTitle(scheduleDetails["weeks"], for: .normal)
        cell?.onlineBtn.setTitleColor((scheduleDetails["classType"] == "Online Class") ? ColorPalette.homeGuruOrangeColor : ColorPalette.whiteColor, for: .normal)
        cell?.onlineBtn.setImage(UIImage(named:(scheduleDetails["classType"] == "Online Class") ?  "orangeVideoClass" : "whiteVideoClass") , for: .normal)
        cell?.atHomeBtn.setTitleColor((scheduleDetails["classType"] == "Online Class") ? ColorPalette.whiteColor : ColorPalette.homeGuruOrangeColor, for: .normal)
        cell?.atHomeBtn.setImage(UIImage(named: (scheduleDetails["classType"] == "Online Class") ? "greyAtHome" : "whiteAtHome"), for: .normal)
        return cell!
    }
    
    func dismissProgramPicker() {
        tableView.isScrollEnabled = true
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.none, animated: false)
        programPickerView?.removeFromSuperview()
    }
    
    func getSelectedProgram(data: String) {
        scheduleDetails[pickerType == .timings ? "timings" : "weeks"] = data
        tableView.isScrollEnabled = true
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.none, animated: false)
    }
    

}
