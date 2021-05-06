//
//  profileSwitchViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 05/05/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit

class profileSwitchViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    var index: Int?
    var studentName: String = ""
    var studentDob: String  = ""
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func switchProfile(_ sender: UIButton) {
        
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshReschedule"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshProfile"), object: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchProfileTableViewCell", for: indexPath) as! SwitchProfileTableViewCell
        cell.studentDOB.text = studentDob
        cell.studentName.text = studentName
        cell.studentAddress.text = StructOperation.glovalVariable.address
        cell.parentEmail.text = StructOperation.glovalVariable.parentEmail
        cell.parentPhone.text = StructOperation.glovalVariable.parentPhone
        return cell
    }

}
