//
//  MyGuruDetailsViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 10/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit

class MyGuruDetailsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var myGurusDetails : [String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "MyGuruCard", bundle: nil), forCellReuseIdentifier: "MyGuruCard")
        hideNavbar()
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playVideoAction(_ sender: UIButton) {
    }
    
    @IBAction func bookClassAction(_ sender: UIButton) {
        let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "SelectSchedule") as! SelectScheduleViewController
                                     //setNavigationBackTitle(title: "Schedule")
                                     vc.hidesBottomBarWhenPushed = true
                                     self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyGuruDetailsInfoCell", for: indexPath) as? MyGuruDetailsTableViewCell
            cell?.guruImage.image = imageWithGradient(img: cell?.guruImage.image)
            cell?.selectionStyle = .none
            return cell!
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyGuruDetailsQualificationInfoCell", for: indexPath) as? MyGuruDetailsTableViewCell
            cell?.selectionStyle = .none
            return cell!
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyGuruDetailsSubjectsInfoCell", for: indexPath) as? MyGuruDetailsTableViewCell
            cell?.selectionStyle = .none
            return cell!
        }
    }
    
    

}
