//
//  RegisterStudentViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 10/10/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Alamofire
import SwiftyJSON
class RegisterStudentViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, RegisterStudentDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    var studentArray: [String]?
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerView_2{
            return classes.count
            

        }else{
            return storeBoard.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == pickerView_2{
             return classes[row]
        }else{
            
            return storeBoard[row]
        }
        
    }
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerView_2{
              selectedClass = classes[row]
                      studentArray?.append(classes[row])
                      print("picker 1....\(selectedClass)")
                      print("picker 1 current index....\(currentIndex)")
            self.studentDetails[currentIndex]["stdClass"] = "1"

//                      self.studentDetails[currentIndex]["stdClass"] = selectedClass
                      print("picker 1 value ....\(self.studentDetails[currentIndex]["stdClass"])")
            
        }else{
                  selectedBoard = storeBoard[row]
                  print("picker 2....\(selectedBoard)")
                  print("picker 2 current index....\(currentIndex)")
                  self.studentDetails[currentIndex]["board"] = "cbse"
//                  self.studentDetails[currentIndex]["board"] = selectedBoard
                      print("picker 2 value ....\(self.studentDetails[currentIndex]["board"])")
        }
            
   }
    @IBOutlet weak var tableView: UITableView!
    var selectedBoard: String = ""
    var selectedClass: String = ""
    var storeBoard: [String] = []
    var studentDetails : [[String:Any]] = []
    var programList : [[String:Any]] = []
    var pgList: [String] = []
    var parentDetails : [String:Any] = [:]
    var numberOfStudents = 1
    var currentIndex = 0
    var boards: [String] = ["class 1","class 10","class 1","class 1","class 1"]
    var classes: [String] = ["class 1","class 2","class 3","class 4","class 5", "class 6", "class 7", "class 8", "class 9", "class 10", "class 11", "class 12"]
    var datePickerView : DatePickerView?
    var programPickerView : ProgramPickerView?
    var pickerType : StateCityPickerType = .state
    @IBOutlet weak var outerPickerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var outerPickerView_2: UIView!
    
    @IBOutlet weak var pickerView_2: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "RegisterStudentTableViewCell", bundle: nil), forCellReuseIdentifier: "RegisterStudentTableViewCell")
        getProgramList()
        pickerView.delegate = self
        pickerView.dataSource = self
       
        pickerView_2.delegate = self
        pickerView_2.dataSource = self
        getBoards()
         hideUnhidePickerView(view: self.outerPickerView, value: true)
        hideUnhidePickerView(view: self.outerPickerView_2, value: true)

    }
    func getBoards(){
        AlamofireService.alamofireService.getRequest(url: URLManager.sharedUrlManager.getBoards, parameters: nil) { response
                    in
                    switch response.result {
                    case .success(let value):
                        if let status =  response.response?.statusCode {
                            print("svis ..\(value)")
                            print("sstatus is ..\(status)")
                            if status == 200 || status == 201 {
                                let json = JSON(value)
                                for arr in json.arrayValue{
                                    self.storeBoard.append(arr["name"].stringValue)
                                    
                                }

                                print("data...\(self.storeBoard)")
                                DispatchQueue.main.async {
                                    self.pickerView.reloadAllComponents()
                                }
                            }
                        }
                    case .failure( _):
                        self.showAlert(title: Constants.unknownTitle, message: Constants.unknownMsg)
                    }
                }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavbar()
    }
    
    @IBAction func registerParentAction(_ sender: UIButton) {
        print("studentDetails is ..\(studentDetails)")
        for (index,value) in studentDetails.enumerated() {
            var obj = value
            obj.removeValue(forKey: "programName")
            studentDetails[index] = obj
        }
        parentDetails["student"] = studentDetails
        print("parentDetails is ..\(parentDetails)")
        registerParent()
    }
    
    func selectDOB(index: Int) {
        endEditing()
        currentIndex = index
        showDatePicker()
    }
//    func selectBoard(index: Int){
//       endEditing()
//        currentIndex = index
//        pickerView.selectedRow(inComponent: 0)
//        pickerView.reloadAllComponents()
//        hideUnhidePickerView(view: self.outerPickerView, value: false)
//    }
//    func selectClass(index: Int){
//        endEditing()
//          currentIndex = index
//          pickerView_2.selectedRow(inComponent: 0)
//          pickerView_2.reloadAllComponents()
//          hideUnhidePickerView(view: self.outerPickerView_2, value: false)
//    }
    func showDatePicker() {
        datePickerView = Bundle.main.loadNibNamed("DatePickerView", owner: self, options: nil)?.first as! DatePickerView
        datePickerView?.delegate = self
        datePickerView?.showDatePickerView(onView: self.tableView)
        tableView.isScrollEnabled = true
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.none, animated: false)
    }
    
    func getNameTextFieldValue(tag: Int, value: String) {
        currentIndex = tag
        studentDetails[currentIndex]["name"] = value
        tableView.reloadRows(at: [IndexPath(row: currentIndex, section: 0)], with: .none)
    }
    
    func getProgramList() {
        AlamofireService.alamofireService.getRequestWithContentType(url: URLManager.sharedUrlManager.getProgramList, parameters: nil) { response in
                switch response.result {
                case .success(let value):
                    if let status =  response.response?.statusCode {
                        print("status is ..\(status)")
                        if status == 200 || status == 201 {
                            if let result = value as? [[String:Any]] {
                                print("result is ..\(result)")
                                self.programList = result
                            }
                        }
                    }
                case .failure( _):
                     print("API call failed...")
                }
        }
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfStudents + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.row == numberOfStudents) ? 100.0 : 413.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            case 0..<numberOfStudents:
                let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterStudentTableViewCell", for: indexPath) as? RegisterStudentTableViewCell
                cell?.delegate = self
                cell?.selectDOBBtn.tag = indexPath.row
               // cell?.selectClassBtn.tag = indexPath.row
                cell?.selectBoardBtn.tag = indexPath.row
                cell?.nameTextField.tag = indexPath.row
               // cell?.boardTextField.inputView = pickerView
                cell?.boardTextField.delegate = self
                cell?.selectionStyle = .none
                cell?.nameTextField.text = ""
                cell?.dobTextField.text = "dd/mm/yyyy"
                cell?.classTextField.text = selectedClass
                cell?.boardTextField.text = selectedBoard
                cell?.studentLabel.text = "Student \(indexPath.row+1)"
                if let name = studentDetails[indexPath.row]["name"] as? String {
                    cell?.nameTextField.text = name
                }
                if let dob = studentDetails[indexPath.row]["dob"] as? String {
                    cell?.dobTextField.text = dob
                }
//                if let classStudent = studentDetails[indexPath.row]["stdClass"] as? String{
//                    cell?.classTextField.text = classStudent
//                }
//                if let board = studentDetails[indexPath.row]["board"] as? String{
//                    cell?.boardTextField.text = board
//                }
                if let program = studentDetails[indexPath.row]["programName"] as? String {
                    cell?.classTextField.text = program
                }
                return cell!
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerStudentActionCell", for: indexPath)
                cell.selectionStyle = .none
                return cell
        }
    }

    @IBAction func dismissPV2(_ sender: UIBarButtonItem) {
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
               hideUnhidePickerView(view: self.outerPickerView_2, value: true)
        reload(tableView: self.tableView)
    }
    @IBAction func dismissPV(_ sender: UIBarButtonItem) {
        
        
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        hideUnhidePickerView(view: self.outerPickerView, value: true)
        reload(tableView: self.tableView)

    }
    func reload(tableView: UITableView) {

        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)

    }
    
}

extension RegisterStudentViewController {
    
    func registerParent() {
        print(URLManager.sharedUrlManager.registerParent)
        let hud = showLoader(onView: tableView)
        if !isNetConnectionAvailable() {
            self.hideLoader(loader: hud)
            self.showAlert(title: "Message", message: "Please Check Your Internet Connection!")
            return
        }
//        parentDetails["password"] = "123456"
//        parentDetails["mobileNo"] = UserDefaults.standard.string(forKey: Constants.mobileNo)
        AlamofireService.alamofireService.postRequestWithBodyData(url: URLManager.sharedUrlManager.registerParent, details: parentDetails) {
        response in
           switch response.result {
           case .success(let value):
               if let status =  response.response?.statusCode {
               print("status is ..\(status)")
                print("value...\(value)")
                   if status == 200 || status == 201 {
                       if let result = value as? [String:Any] {
                            print("result is ...\(result)")
                            if let token = result["token"] as? String, let parentDetails = result["parent"] as? [String:Any] {
                                print("new token...\(token)")
                                UserDefaults.standard.set(token, forKey: Constants.token)
                                ParentDetails.parentDetails.saveData(data: parentDetails, token: token)
                                
                            }
                        let json = JSON(value)
                        // store student id
                        StructOperation.glovalVariable.studentId = json["parent"]["student"][0]["_id"].stringValue
                        
                        print("stu....\(StructOperation.glovalVariable.studentId)")
                        // store student id ends
                            hud.hide(animated: true)
                            UserDefaults.standard.set(true, forKey: Constants.isRegistered)
                            UserDefaults.standard.set(json["parent"]["student"][0]["_id"].stringValue, forKey: "studentId")
                            
                            UserDefaults.standard.set(0,forKey: Constants.currentSelectedStudentProfile)
                            self.showAlert(title: "Message", message: "User Registered Successfully!")
                            UserDefaults.standard.set(true, forKey: Constants.loginStatus)
                            DispatchQueue.main.async {
                                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                                appDelegate.isLoggedIn()
                            }
                       }
                   }
               }
           case .failure( _):
                if let status =  response.response?.statusCode {
                    self.hideLoader(loader: hud)
                    self.showAlert(title: "Message", message: (status == 400) ? "User with \(self.parentDetails["email"] ?? "") \(self.parentDetails["mobileNo"] ?? "") Already Exists!" : Constants.serverDownMessage)
                    return
                }
           }
       }
    }
}

extension RegisterStudentViewController: DatePickerProtocol {
    
    func dismiss() {
        tableView.isScrollEnabled = true
        tableView.scrollToRow(at: IndexPath(row: currentIndex, section: 0), at: UITableView.ScrollPosition.none, animated: false)
        datePickerView?.removeFromSuperview()
    }
    
    func getSelectedDate(date: String) {
        let dateObj = getDateFromString(format: "dd/MM/yyyy", dateString: date)
        studentDetails[currentIndex]["dob"] = getDateString(format: "yyyy-MM-dd", date:  dateObj)
        getProgram(months: Date().months(from: dateObj))
        tableView.reloadData()
    }
    
    func getProgram(months: Int) {
        var isSet = false
        for item in programList {
            if let monthRange = item["monthRange"] as? [String:Int] {
                if let minMonth = monthRange["minMonth"] as? Int, let maxMonth = monthRange["maxMonth"] as? Int {
                    if months >= minMonth && months <= maxMonth {
                        self.studentDetails[currentIndex]["programName"] = item["program"] as! String
                        isSet = true
                    }
                }
            }
        }
        if isSet {
            studentDetails[currentIndex]["residentalAddress"] = "0"
            tableView.isScrollEnabled = true
            tableView.reloadRows(at: [IndexPath(row: currentIndex, section: 0)], with: .none)
            tableView.scrollToRow(at: IndexPath(row: currentIndex, section: 0), at: UITableView.ScrollPosition.none, animated: false)
        } else {
            self.showAlert(title: "Message", message: "Please Select valid Dob!")
        }
    }
    
    
    
}

