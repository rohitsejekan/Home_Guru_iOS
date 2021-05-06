//
//  editProfileViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 19/04/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit
import SwiftyJSON
protocol updateProfile: class {
    func updateP()
}
class editProfileViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var updateDelegate: updateProfile!
    var editDetails: [String: String] = [:]
    var sendEditedDetails: [String: String] = [:]
    //for datepicker
       var studentDates: String = ""
    // for date picker ends
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var outerPickerView: UIView!
    var datePickerView1 : DatePickerView?
    var selectedClass: String = ""
     var classes: [String] = ["class 1","class 2","class 3","class 4","class 5", "class 6", "class 7", "class 8", "class 9", "class 10", "class 11", "class 12"]
    
    // datepicker implementation
     func showDatePicker() {
          datePickerView1 = Bundle.main.loadNibNamed("DatePickerView", owner: self, options: nil)?.first as! DatePickerView
          datePickerView1?.delegate = self
          datePickerView1?.showDatePickerView(onView: self.tableView)
          tableView.isScrollEnabled = true
          tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.none, animated: false)
      }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            return 70
        }else{
            return UITableView.automaticDimension
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "editProfile") as! editProfileTableViewCell
                cell.editName.delegate = self
                cell.editName.tag = 0
                cell.datePickerDelegate = self
//                cell.editDate.delegate = self
//                cell.editDate.tag = 1
//                cell.editYear.delegate = self
//                cell.editYear.tag = 2
//                cell.editMonth.delegate = self
//                cell.editMonth.tag = 3
                //cell.editClass.setTitle(selectedClass, for: .normal)
               // cell.editClass.contentHorizontalAlignment = .left
              cell.dobBtn.setTitle(studentDates, for: .normal)
                return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "customButton", for: indexPath) as! customButtonTableViewCell
                      cell.goToDelegate = self
                      return cell
        }
    
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = UITableView.automaticDimension
        //back button
        backBtn.layer.cornerRadius = 3
        //hide pickerview container
        outerPickerView.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self
        // custom cell
        tableView.register(UINib(nibName: "customButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "customButton")
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        self.updateDelegate.updateP()
        self.navigationController?.popViewController(animated: true)
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
    @IBAction func buttonPickerView(_ sender: UIButton) {
//        if outerPickerView.isHidden{
//            outerPickerView.isHidden = false
//        }

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag{
        case 0:
            editDetails["name"] = textField.text
        case 1:
            editDetails["date"] = textField.text
        case 2:
            editDetails["month"] = textField.text
        case 3:
            editDetails["year"] = textField.text
       
        default:
            print("default")
            
        }
    }
    private func goAndEdit(){
             sendEditedDetails["name"] = editDetails["name"]
             sendEditedDetails["stdClass"] = selectedClass
             sendEditedDetails["studentId"] = StructOperation.glovalVariable.studentId
             sendEditedDetails["dob"] = "2020-02-03"
                AlamofireService.alamofireService.postRequestWithBodyDataAndToken(url: URLManager.sharedUrlManager.updateStudent, details: sendEditedDetails) {
                response in
                   switch response.result {
                   case .success(let value):
                       if let status = response.response?.statusCode {
                       print("status issw ..\(status)")
                        print("value...\(value)")
                           if status == 200 || status == 201 {
                       // pop alert controller
                            let alert = UIAlertController(title: "Editing", message: "Edited successfully", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshEditing"), object: nil)
                                self.navigationController?.popToRootViewController(animated: true)
                            }))
                            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
                           }else{
                            print("server error")
                            let alert = UIAlertController(title: "PROFILE UPDATE", message: "OOPS!!! SOMETHING WENT WRONG", preferredStyle: .alert)
                                               
                            let cancel = UIAlertAction(title: "ok", style: .default, handler: nil)
                                               
                            alert.addAction(cancel)
                            self.present(alert, animated: true, completion: nil)
                        }
                       }
                   case .failure( _):
                       print("failure")
                            return
                        }
                   }
    }
    
    

}

extension editProfileViewController: nextScreen{
    func gotoScreen() {
    print("button pressed")
            goAndEdit()
    }
}
extension editProfileViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return classes.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
      return classes[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedClass = classes[row]
        print("selectedclass..\(selectedClass)")
    }
    
}
extension editProfileViewController: DatePickerProtocol,showDatePicker {
    func datePicker() {
        showDatePicker()
    }
    
 
 func dismiss() {
     tableView.isScrollEnabled = true
     tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.none, animated: false)
     datePickerView1?.removeFromSuperview()
 }
 
 func getSelectedDate(date: String) {
     let dateObj = getDateFromString(format: "dd/MM/yyyy", dateString: date)
     studentDates = getDateString(format: "yyyy-MM-dd", date:  dateObj)
     //getProgram(months: Date().months(from: dateObj))
     tableView.reloadData()
 }
 

 }
