//
//  editProfileViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 19/04/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit
import SwiftyJSON
class editProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var editDetails: [String: String] = [:]
    var sendEditedDetails: [String: String] = [:]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "editProfile") as! editProfileTableViewCell
                cell.editName.delegate = self
                cell.editName.tag = 0
                cell.editDate.delegate = self
                cell.editDate.tag = 1
                cell.editYear.delegate = self
                cell.editYear.tag = 2
                cell.editMonth.delegate = self
                cell.editMonth.tag = 3
                cell.editClass.delegate = self
                cell.editClass.tag = 4
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
        
        // custom cell
        tableView.register(UINib(nibName: "customButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "customButton")
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
        case 4:
            editDetails["class"] = textField.text
        default:
            print("default")
            
        }
    }
    private func goAndEdit(){
             sendEditedDetails["name"] = editDetails["name"]
             sendEditedDetails["stdClass"] = editDetails["stdClass"]
             sendEditedDetails["studentId"] = ""
             sendEditedDetails["dob"] = "2020-02-03"
                AlamofireService.alamofireService.postRequestWithBodyDataAndToken(url: URLManager.sharedUrlManager.addProfile, details: sendEditedDetails) {
                response in
                   switch response.result {
                   case .success(let value):
                       if let status =  response.response?.statusCode {
                       print("status issw ..\(status)")
                        print("value...\(value)")
                           if status == 200 || status == 201 {
                        let val = JSON(value)
                            
                                                  
                      
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
