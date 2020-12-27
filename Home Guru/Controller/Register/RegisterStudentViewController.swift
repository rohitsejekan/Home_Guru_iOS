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

class RegisterStudentViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, RegisterStudentDelegate {

    @IBOutlet weak var tableView: UITableView!

    var studentDetails : [[String:Any]] = []
    var programList : [[String:Any]] = []
    var parentDetails : [String:Any] = [:]
    var numberOfStudents = 1
    var currentIndex = 0
    var datePickerView : DatePickerView?
    var programPickerView : ProgramPickerView?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "RegisterStudentTableViewCell", bundle: nil), forCellReuseIdentifier: "RegisterStudentTableViewCell")
        getProgramList()
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
    
    func showDatePicker() {
        datePickerView = Bundle.main.loadNibNamed("DatePickerView", owner: self, options: nil)?.first as! DatePickerView
        datePickerView?.delegate = self
        datePickerView?.showDatePickerView(onView: self.tableView)
        tableView.isScrollEnabled = false
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
                cell?.selectClassBtn.tag = indexPath.row
                cell?.selectBoardBtn.tag = indexPath.row
                cell?.nameTextField.tag = indexPath.row
                cell?.selectionStyle = .none
                cell?.nameTextField.text = ""
                cell?.dobTextField.text = "dd/mm/yyyy"
                cell?.classTextField.text = ""
                cell?.boardTextField.text = ""
                cell?.studentLabel.text = "Student \(indexPath.row+1)"
                if let name = studentDetails[indexPath.row]["name"] as? String {
                    cell?.nameTextField.text = name
                }
                if let dob = studentDetails[indexPath.row]["dob"] as? String {
                    cell?.dobTextField.text = dob
                }
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
        parentDetails["password"] = "123456"
        parentDetails["mobileNo"] = UserDefaults.standard.string(forKey: Constants.mobileNo)
        AlamofireService.alamofireService.postRequestWithBodyData(url: URLManager.sharedUrlManager.registerParent, details: parentDetails) {
        response in
           switch response.result {
           case .success(let value):
               if let status =  response.response?.statusCode {
               print("status is ..\(status)")
                   if status == 200 || status == 201 {
                       if let result = value as? [String:Any] {
                            print("result is ...\(result)")
                            if let token = result["token"] as? String, let parentDetails = result["parent"] as? [String:Any] {
                                UserDefaults.standard.set(token, forKey: Constants.token)
                                ParentDetails.parentDetails.saveData(data: parentDetails, token: token)
                            }
                            hud.hide(animated: true)
                            UserDefaults.standard.set(true, forKey: Constants.isRegistered)
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

