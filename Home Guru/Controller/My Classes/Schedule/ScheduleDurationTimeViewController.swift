//
//  ScheduleDurationTimeViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 12/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit
enum PickerTypee {
    case timings, weeks
}


class ScheduleDurationTimeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,ProgramPickerProtocol {
    
    @IBOutlet weak var backBtn: UIButton!
    var getCheckedName: [String] = []
    var selectedCounts: Int?
    func dismissProgramPicker() {
        tableView.isScrollEnabled = true
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.none, animated: false)
        programPickerView?.removeFromSuperview()
    }
    
    func getSelectedProgram(programName data: String) {
         scheduleDetails[pickerType == .timings ? "timings" : "weeks"] = data
               tableView.isScrollEnabled = true
               tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
               tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.none, animated: false)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
                  let cell = tableView.dequeueReusableCell(withIdentifier: "DurationTime", for: indexPath) as? DurationTimeTableViewCell
                 
                    cell?.selectionStyle = .none
            cell?.subjectName.text = getCheckedName[indexPath.row]
                  cell?.preservesSuperviewLayoutMargins = false
                  cell?.separatorInset = .zero
                  cell?.layoutMargins = .zero
                  cell?.subjectName.layer.cornerRadius = 8
                       cell?.subjectName.layer.borderColor = ColorPalette.homeGuruOrangeColor.cgColor
                       cell?.subjectName.layer.borderWidth = 1
            
            //        cell?.radioImageView.image = UIImage(named: indexPath.row == index ? "radioSelected" : "radioUnselected")
                  
                    return cell!
        }else  if indexPath.row < getCheckedName.count ?? 2{
                  let cell = tableView.dequeueReusableCell(withIdentifier: "DurationTime", for: indexPath) as? DurationTimeTableViewCell
                 
                    cell?.selectionStyle = .none
            cell?.subjectName.text = getCheckedName[indexPath.row]
                  cell?.preservesSuperviewLayoutMargins = false
                  cell?.separatorInset = .zero
                  cell?.layoutMargins = .zero
            cell?.contentHeight.constant = 0
            cell?.subjectName.layer.cornerRadius = 8
            cell?.subjectName.layer.borderColor = ColorPalette.homeGuruOrangeColor.cgColor
            cell?.subjectName.layer.borderWidth = 1
            
          
            //        cell?.radioImageView.image = UIImage(named: indexPath.row == index ? "radioSelected" : "radioUnselected")
                  
                    return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "customButton", for: indexPath) as! customButtonTableViewCell
            cell.goToDelegate = self
            cell.selectionStyle = .none
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = .zero
            cell.layoutMargins = .zero

                        return cell
        }
     
    }
    @IBAction func selectDuration(_ sender: Any) {
        showProgramPicker(pickerType: .timings)
    }
    
    @IBAction func selectTime(_ sender: Any) {
        showProgramPicker(pickerType: .weeks)

    }
    func showProgramPicker(pickerType: PickerType) {
        self.pickerType = pickerType
        programPickerView = Bundle.main.loadNibNamed("ProgramPickerView", owner: self, options: nil)?.first as! ProgramPickerView
        programPickerView?.delegate = self
       // programPickerView?.programList = (pickerType == .timings) ? timingsList : weeksList
        programPickerView?.showProgramPickerView(onView: self.tableView)
        tableView.isScrollEnabled = false
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.none, animated: false)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         
            return getCheckedName.count + 1
       
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 300
        }else if indexPath.row < getCheckedName.count{
            return 200
        }else{
            return 100
        }
        
    }
    
var pickerType : PickerType = .timings
 var scheduleDetails : [String:String] = ["classType" : "Online Class","timings":"select","weeks":"2 weeks"]
  var programPickerView : ProgramPickerView?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

           tableView.register(UINib(nibName: "customButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "customButton")
        
        backBtn.layer.cornerRadius = 5
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func goBack(_ sender: Any) {
       // self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
}
extension ScheduleDurationTimeViewController: nextScreen{
    func gotoScreen() {
         let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "SelectGuru") as! SelectGuruViewController
                              //setNavigationBackTitle(title: "Schedule")
                              vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: false)
        
        
    }
    
    
}
