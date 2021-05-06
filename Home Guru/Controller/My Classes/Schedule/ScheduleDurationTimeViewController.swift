//
//  ScheduleDurationTimeViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 12/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.


enum PickerTypee {
    case timings, weeks
}
import UIKit
import JJFloatingActionButton
class ScheduleDurationTimeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource,ProgramPickerProtocol,DurtionTimeDelegate,UIPickerViewDataSource, UIPickerViewDelegate{
    
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         if pickerView == pickerViewDuration{
             return duration.count
             

         }else{
             return classes.count
         }
     }
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
     {
         if pickerView == pickerViewDuration{
              return duration[row]
         }else{
             
             return classes[row]
         }
         
     }
     func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         if pickerView == pickerViewDuration{
            
            selectedBoard = duration[row]
                              print("picker 2....\(selectedBoard)")
                              print("picker 2 current index....\(currentIndex)")
                              self.studentDetails[currentIndex]["start"] = selectedBoard
                             studentDetails[currentIndex]["name"] = getCheckedName[currentIndex]
                                  print("picker 2 value ....\(self.studentDetails[currentIndex]["start"])")
             
         }else{
                    selectedClass = classes[row]
                                       studentArray?.append(classes[row])
                                       print("picker 1....\(selectedClass)")
                                       print("picker 1 current index....\(currentIndex)")
                                        studentDetails[currentIndex]["name"] = getCheckedName[currentIndex]
                                       self.studentDetails[currentIndex]["duration"] = selectedClass
                            
                                       print("picker 1 value ....\(self.studentDetails[currentIndex]["duration"])")
         }
             
    }
    func selectDuration(index: Int) {
        if outerPickerDurationView.isHidden{
            outerPickerDurationView.isHidden = false
        }
        currentIndex = index
    }
    
    func getStartTime(index: Int) {
       
        
        timeTruncate = String(pickerViewTime.date.string(format: "HH:mm"))
            let arr = timeTruncate.prefix(36)
            ScheduleTime = String(arr.suffix(11))
     
        print("picker date.....\(ScheduleTime)")
        print("picker date.....\(timeTruncate)")
         self.studentDetails[index]["duration"] = "\(timeTruncate)"
        if outerPickerView2.isHidden{
            outerPickerView2.isHidden = false
        }
        currentIndex = index
    }
    
    func serverToLocal(date:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let localDate = dateFormatter.date(from: date)

        return localDate
    }
    var timeTruncate: String = ""
    var duration: [String] = ["01 Hour","1.5 Hour","02 Hour","2.5 Hour","03 Hour", "3.5 Hour","4 Hour"]
    var classes: [String] = ["class 1","class 2","class 3","class 4","class 5", "class 6", "class 7", "class 8", "class 9", "class 10", "class 11", "class 12"]
    var slotDetails : [String:Any] = [:]
    var studentArray: [String]?
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var outerPickerDurationView: UIView!
    @IBOutlet weak var outerPickerView2: UIView!
    var currentIndex = 0
    var selectedClass: String = ""
    var ScheduleTime: String = ""
    var selectedBoard: String = ""
    var studentDetails : [[String:Any]] = []
    var getCheckedName: [String] = []
    var timeArray: [String] = []
    var durationArray: [String] = []
    var storeBoard: [String] = []
    let actionButton = JJFloatingActionButton()
    @IBOutlet weak var pickerViewDuration: UIPickerView!
    
    @IBOutlet weak var pickerViewTime: UIDatePicker!
    var selectedCounts: Int?
    func dismissProgramPicker() {
        tableView.isScrollEnabled = true
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.none, animated: false)
        programPickerView?.removeFromSuperview()
        pickerViewDuration.delegate = self
        pickerViewDuration.dataSource = self
        
       // pickerViewTime.delegate = self
        //pickerViewTime.dataSource = self
        
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
   var scheduleDetails : [String:String] = ["classType" : "Online Class","timings":"select","weeks":"select"]
   var programPickerView : ProgramPickerView?
    @IBOutlet weak var tableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        //floating button
        floatingButton()
        actionButton.buttonDiameter = 65
        actionButton.buttonImageSize = CGSize(width: 35, height: 35)
        //floating button ends

           tableView.register(UINib(nibName: "customButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "customButton")
        outerPickerDurationView.isHidden = true
        outerPickerView2.isHidden = true
          backBtn.layer.cornerRadius = 5
         pickerViewTime.datePickerMode = .time
        
       
       // hideUnhidePickerView(view: self.outerPickerView, value: true)
//        hideUnhidePickerView(view: self.outerPickerView2, value: true)
        
    }
    

    @IBAction func goBack(_ sender: Any) {
       // self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
  
    @IBAction func dismissPV1(_ sender: UIBarButtonItem) {
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
               hideUnhidePickerView(view: self.outerPickerDurationView, value: true)
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
       
        
               for info in studentDetails{
                   for _ in info{
                       timeArray.append(info["duration"] as! String)
                       durationArray.append(info["start"] as! String)
                       break
                   }
               }
               print("slot details....\(studentDetails)")
               print("timeArray....\(timeArray)")
               print("durationArray....\(durationArray)")
               UserDefaults.standard.set(slotDetails, forKey: "dict")
        let defaults = UserDefaults.standard
        defaults.set(slotDetails, forKey: "savedSubjects")
        //vc.slotDetails = slotDetails
        vc.selectedSlot = timeArray
        vc.selectedDuration = durationArray
        StructOperation.glovalVariable.timeSlotFrom = timeArray
        vc.slotDetails["subject"] = studentDetails
       UserDefaults.standard.set(slotDetails, forKey: "dict")

        
        self.navigationController?.pushViewController(vc, animated: false)
        
        
    }
  
}
extension Date {
    var localTime: String {
        return description(with: NSLocale.current)
    }
}
extension Date {
    func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}

        return localDate
    }
}
extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
extension ScheduleDurationTimeViewController{
    func floatingButton(){
              actionButton.addItem(title: "whatsApp", image: UIImage(named: "whatsApp")?.withRenderingMode(.alwaysTemplate)) { item in
              
                         
                         if let whatsappURL = URL(string: "https://api.whatsapp.com/send?phone=+919001990019&text=Invitation"), UIApplication.shared.canOpenURL(whatsappURL) {
                                        if #available(iOS 10, *) {
                                            UIApplication.shared.open(whatsappURL)
                                        } else {
                                            UIApplication.shared.openURL(whatsappURL)
                                        }
                         }
                     }

                     actionButton.addItem(title: "call", image: UIImage(named: "mdi_call")?.withRenderingMode(.alwaysTemplate)) { item in
                       // do something
                   if let url = URL(string: "tel://\(Constants.contactUs)"), UIApplication.shared.canOpenURL(url) {
                                      if #available(iOS 10, *) {
                                          UIApplication.shared.open(url)
                                      } else {
                                          UIApplication.shared.openURL(url)
                                      }
                                  }
                     }

                     actionButton.buttonImage = UIImage(named: "customer-service")
                     actionButton.buttonColor = ColorPalette.homeGuruDarkGreyColor
                     view.addSubview(actionButton)
                     actionButton.translatesAutoresizingMaskIntoConstraints = false
                     if #available(iOS 11.0, *) {
                         actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
                     } else {
                         // Fallback on earlier versions
                         actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
                     }
                     if #available(iOS 11.0, *) {
                         actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
                     } else {
                         // Fallback on earlier versions
                         actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
                     }
          }
          
}
