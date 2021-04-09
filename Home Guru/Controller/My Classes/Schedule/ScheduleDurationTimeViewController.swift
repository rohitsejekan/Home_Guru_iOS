//
//  ScheduleDurationTimeViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 12/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.

import UIKit
enum PickerTypee {
    case timings, weeks
}
class ScheduleDurationTimeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource,ProgramPickerProtocol,DurtionTimeDelegate,UIPickerViewDataSource, UIPickerViewDelegate{
    
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         if pickerView == pickerView_2{
             return classes.count
             

         }else{
             return boards.count
         }
     }
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
     {
         if pickerView == pickerView_2{
              return classes[row]
         }else{
             
             return boards[row]
         }
         
     }
     func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         if pickerView == pickerView_2{
               selectedClass = classes[row]
                       studentArray?.append(classes[row])
                       print("picker 1....\(selectedClass)")
                       print("picker 1 current index....\(currentIndex)")
                        studentDetails[currentIndex]["name"] = getCheckedName[currentIndex]
                       self.studentDetails[currentIndex]["duration"] = selectedClass
            
                       print("picker 1 value ....\(self.studentDetails[currentIndex]["duration"])")
             
         }else{
                   selectedBoard = boards[row]
                   print("picker 2....\(selectedBoard)")
                   print("picker 2 current index....\(currentIndex)")
                   self.studentDetails[currentIndex]["start"] = selectedBoard
                  studentDetails[currentIndex]["name"] = getCheckedName[currentIndex]
                       print("picker 2 value ....\(self.studentDetails[currentIndex]["start"])")
         }
             
    }
    func selectDuration(index: Int) {
        if outerPickerView2.isHidden{
            outerPickerView2.isHidden = false
        }
        currentIndex = index
    }
    
    func getStartTime(index: Int) {
        if outerPickerView.isHidden{
            outerPickerView.isHidden = false
        }
        currentIndex = index
    }
    
    
    var boards: [String] = ["class 1","class 10","class 1","class 1","class 1"]
    var classes: [String] = ["class 1","class 2","class 3","class 4","class 5", "class 6", "class 7", "class 8", "class 9", "class 10", "class 11", "class 12"]
    var slotDetails : [String:Any] = [:]
    var studentArray: [String]?
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var outerPickerView: UIView!
    @IBOutlet weak var outerPickerView2: UIView!
    
    
    var currentIndex = 0
    var selectedClass: String = ""
    var selectedBoard: String = ""
    var studentDetails : [[String:Any]] = []
    var getCheckedName: [String] = []
   var weeksList : [String] = ["weekends","weekdays","both"]
     var timingsList : [String] = ["one weeks","two weeks","four weeks","six weeks"]
    var storeBoard: [String] = []
    
    @IBOutlet weak var pickerView_1: UIPickerView!
    @IBOutlet weak var pickerView_2: UIPickerView!
    var selectedCounts: Int?
    func dismissProgramPicker() {
        tableView.isScrollEnabled = true
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.none, animated: false)
        programPickerView?.removeFromSuperview()
        pickerView_1.delegate = self
        pickerView_1.dataSource = self
        
        pickerView_2.delegate = self
        pickerView_2.dataSource = self
        pickerView_1.isHidden = true
        pickerView_2.isHidden = true
    }
    
    func getSelectedProgram(programName data: String) {
         scheduleDetails[pickerType == .timings ? "timings" : "weeks"] = data
        print("..slot..\(self.currentIndex)")
        //self.slotDetails[currentIndex]["durationSlot"] = data
        
        print("..slot1..\(currentIndex)")
               tableView.isScrollEnabled = true
               tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
               tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.none, animated: false)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
                  let cell = tableView.dequeueReusableCell(withIdentifier: "DurationTime", for: indexPath) as? DurationTimeTableViewCell
                 cell?.selectDuration.setTitle(scheduleDetails["timings"], for: .normal)
                       cell?.selectStartTime.setTitle(scheduleDetails["weeks"], for: .normal)
                    cell?.selectionStyle = .none
                cell?.delegate = self
                cell?.subjectName.text = getCheckedName[indexPath.row]
             
                cell?.preservesSuperviewLayoutMargins = false
                cell?.separatorInset = .zero
                cell?.layoutMargins = .zero
                cell?.selectDuration.tag = indexPath.row
                cell?.selectStartTime.tag = indexPath.row
                cell?.subjectName.layer.cornerRadius = 8
                cell?.subjectName.layer.borderColor = ColorPalette.homeGuruOrangeColor.cgColor
                       cell?.subjectName.layer.borderWidth = 1
            if let duration = studentDetails[indexPath.row]["duration"] as? String{

            cell?.selectDuration.setTitle(duration, for: .normal)

            }
            if let startTime = studentDetails[indexPath.row]["start"] as? String{

                      cell?.selectStartTime.setTitle(startTime, for: .normal)

                      }

            
            //        cell?.radioImageView.image = UIImage(named: indexPath.row == index ? "radioSelected" : "radioUnselected")
                  
                    return cell!
        }else  if indexPath.row < getCheckedName.count ?? 2{
                  let cell = tableView.dequeueReusableCell(withIdentifier: "DurationTime", for: indexPath) as? DurationTimeTableViewCell
            cell?.delegate = self
                    cell?.selectionStyle = .none
            cell?.subjectName.text = getCheckedName[indexPath.row]
                  cell?.preservesSuperviewLayoutMargins = false
            
                  cell?.separatorInset = .zero
                  cell?.layoutMargins = .zero
            cell?.selectDuration.tag = indexPath.row
            cell?.selectStartTime.tag = indexPath.row
            cell?.contentHeight.constant = 0
            cell?.subjectName.layer.cornerRadius = 8
            cell?.subjectName.layer.borderColor = ColorPalette.homeGuruOrangeColor.cgColor
            cell?.subjectName.layer.borderWidth = 1
            if let duration = studentDetails[indexPath.row]["duration"] as? String{

                   cell?.selectDuration.setTitle(duration, for: .normal)

                   }
                   if let startTime = studentDetails[indexPath.row]["start"] as? String{

                             cell?.selectStartTime.setTitle(startTime, for: .normal)

                             }
          
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
//    @IBAction func selectDuration(_ sender: Any) {
//        showProgramPicker(pickerType: .timings)
//    }
//    
//    @IBAction func selectTime(_ sender: Any) {
//        showProgramPicker(pickerType: .weeks)
//
//    }
//    func showProgramPicker(pickerType: PickerType) {
//        self.pickerType = pickerType
//        programPickerView = Bundle.main.loadNibNamed("ProgramPickerView", owner: self, options: nil)?.first as! ProgramPickerView
//        programPickerView?.delegate = self
//       programPickerView?.pgList = (pickerType == .timings) ? timingsList : weeksList
//        programPickerView?.pgStatus = false
//        programPickerView?.showProgramPickerView(onView: self.tableView)
//        tableView.isScrollEnabled = false
//        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.none, animated: false)
//    }
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
        outerPickerView.isHidden = true
        outerPickerView2.isHidden = true
          backBtn.layer.cornerRadius = 5
//        hideUnhidePickerView(view: self.outerPickerView, value: true)
//        hideUnhidePickerView(view: self.outerPickerView2, value: true)
        
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
    
  
    @IBAction func dismissPV1(_ sender: UIBarButtonItem) {
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
               hideUnhidePickerView(view: self.outerPickerView, value: true)
        reload(tableView: self.tableView)
    }
    @IBAction func dismissPV(_ sender: UIBarButtonItem) {
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
               hideUnhidePickerView(view: self.outerPickerView2, value: true)
        reload(tableView: self.tableView)
    }
    func reload(tableView: UITableView) {

          let contentOffset = tableView.contentOffset
          tableView.reloadData()
          tableView.layoutIfNeeded()
          tableView.setContentOffset(contentOffset, animated: false)

      }
    
}
extension ScheduleDurationTimeViewController: nextScreen{
    func gotoScreen() {
         let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "SelectGuru") as! SelectGuruViewController
                              //setNavigationBackTitle(title: "Schedule")
                              vc.hidesBottomBarWhenPushed = true
       

        let defaults = UserDefaults.standard
        defaults.set(slotDetails, forKey: "savedSubjects")
        vc.slotDetails = slotDetails
        slotDetails["subject"] = studentDetails
        
        UserDefaults.standard.set(slotDetails, forKey: "dict")
        
        self.navigationController?.pushViewController(vc, animated: false)
        
        
    }
    
    
}
