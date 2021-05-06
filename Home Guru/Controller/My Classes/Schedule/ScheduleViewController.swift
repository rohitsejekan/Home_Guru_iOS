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
import JJFloatingActionButton
class ScheduleViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, ProgramPickerProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backView: UIButton!
    var selectedDropDown: Bool = false
    var programPickerView : ProgramPickerView?
    var weeksList : [String] = ["weekends","weekdays","both"]
    var timingsList : [String] = ["one weeks","two weeks","four weeks","six weeks"]
    var pickerType : PickerType = .timings
    var scheduleDetails : [String:String] = ["classType" : "Online Class","timings":"select","weeks":"select"]
    let actionButton = JJFloatingActionButton()
    override func viewDidLoad(){
        super.viewDidLoad()
        //floating button
        floatingButton()
        actionButton.buttonDiameter = 65
        actionButton.buttonImageSize = CGSize(width: 35, height: 35)
        
        //floating button ends
        tableView.estimatedRowHeight = 498.0
        tableView.rowHeight = UITableView.automaticDimension
        backView.layer.cornerRadius = 5
          UserDefaults.standard.set("2", forKey: "classType")
        print("retrive....\(UserDefaults.standard.string(forKey: "classType"))")
    }
    
    @IBAction func chooseClassTypeAction(_ sender: UIButton) {
        scheduleDetails["classType"] = sender.tag == 0 ? "At Home" : "Online Class"
        if sender.tag == 0{
            UserDefaults.standard.set("1", forKey: "classType")
            print("retrive 1....\(UserDefaults.standard.string(forKey: "classType"))")
        }else{
            UserDefaults.standard.set("2", forKey: "classType")
              print("retrive 2....\(UserDefaults.standard.string(forKey: "classType"))")
        }
        self.tableView.reloadData()
    }
    
    @IBAction func chooseTimingsAction(_ sender: UIButton) {
        showProgramPicker(pickerType: .timings)
    }
    
    @IBAction func noOfWeeksAction(_ sender: UIButton) {
        showProgramPicker(pickerType: .weeks)
    }
    @IBAction func nextAction(_ sender: UIButton) {
        
            if selectedDropDown == false{
                let alert = UIAlertController(title: "Alert", message: "please fill the required information", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
            }else{
                let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "ScheduleSubjectViewController") as! ScheduleSubjectViewController
                    setNavigationBackTitle(title: "Select Subject")
                if let weeks = scheduleDetails["timings"]{
                    if weeks == "one weeks"{
                        
                        StructOperation.glovalVariable.noOfweeks = String(1)
                    }else if weeks == "six weeks"{
                        
                        StructOperation.glovalVariable.noOfweeks = String(6)
                    }
                    else if weeks == "two weeks"{
                        
                        StructOperation.glovalVariable.noOfweeks = String(2)
                    }
                    else if weeks == "four weeks"{
                        
                        StructOperation.glovalVariable.noOfweeks = String(4)
                    }
                    
                }
                print("weeks...\(StructOperation.glovalVariable.noOfweeks)")
                
                self.navigationController?.pushViewController(vc, animated: false)
            }
        
        
  
    }
    
    func showProgramPicker(pickerType: PickerType) {
        self.pickerType = pickerType
        programPickerView = Bundle.main.loadNibNamed("ProgramPickerView", owner: self, options: nil)?.first as! ProgramPickerView
        programPickerView?.delegate = self
        programPickerView?.pgStatus = false
        programPickerView?.pgList = (pickerType == .timings) ? timingsList : weeksList
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
        if let weekTypo = scheduleDetails["weeks"]{
            UserDefaults.standard.set("\(weekTypo)", forKey: "typeOfweeks")
        }
        
              
        cell?.noOfWeeksBtn.setTitle(scheduleDetails["weeks"], for: .normal)
            
        cell?.onlineBtn.setTitleColor((scheduleDetails["classType"] == "Online Class") ? ColorPalette.homeGuruOrangeColor : ColorPalette.whiteColor, for: .normal)
        cell?.onlineBtn.setImage(UIImage(named:(scheduleDetails["classType"] == "Online Class") ?  "orangeVideoClass" : "onlineWhite") , for: .normal)
        cell?.atHomeBtn.setTitleColor((scheduleDetails["classType"] == "Online Class") ? ColorPalette.whiteColor : ColorPalette.homeGuruOrangeColor, for: .normal)
        cell?.atHomeBtn.setImage(UIImage(named: (scheduleDetails["classType"] == "Online Class") ? "whiteAtHome" : "orangeHome"), for: .normal)
        cell?.selectionStyle = .none
        return cell!
    }
    
    func dismissProgramPicker() {
        tableView.isScrollEnabled = true
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.none, animated: false)
        programPickerView?.removeFromSuperview()
    }
    
    func getSelectedProgram(programName data: String) {
        selectedDropDown = true
        print("selected...data..\(data)")
       
        scheduleDetails[pickerType == .timings ? "timings" : "weeks"] = data
        tableView.isScrollEnabled = true
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.none, animated: false)
    }
    

    @IBAction func goBack(_ sender: Any) {
       // self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
}

extension ScheduleViewController{
    func floatingButton(){
              actionButton.addItem(title: "", image: UIImage(named: "whatsApp")?.withRenderingMode(.alwaysTemplate)) { item in
              
                         
                         if let whatsappURL = URL(string: "https://api.whatsapp.com/send?phone=+919001990019&text=Invitation"), UIApplication.shared.canOpenURL(whatsappURL) {
                                        if #available(iOS 10, *) {
                                            UIApplication.shared.open(whatsappURL)
                                        } else {
                                            UIApplication.shared.openURL(whatsappURL)
                                        }
                         }
                     }

                     actionButton.addItem(title: "", image: UIImage(named: "mdi_call")?.withRenderingMode(.alwaysTemplate)) { item in
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
