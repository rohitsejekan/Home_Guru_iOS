//
//  NotificationsViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 20/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var notifications : [[String:Any]] = [["title":"Lorem ipsum dolor sit amet","desc":"Lorem ipsum dolor sit amet, consectetur\nLorem ipsum dolor sit amet, consectetur","date":"11 January"],["title":"Lorem ipsum dolor sit amet","desc":"Lorem ipsum dolor sit amet, consectetur\nLorem ipsum dolor sit amet, consectetur","date":"11 January"],["title":"Lorem ipsum dolor sit amet","desc":"Lorem ipsum dolor sit amet, consectetur\nLorem ipsum dolor sit amet, consectetur","date":"11 January"],["title":"Lorem ipsum dolor sit amet","desc":"Lorem ipsum dolor sit amet, consectetur\nLorem ipsum dolor sit amet, consectetur","date":"11 January"],["title":"Lorem ipsum dolor sit amet","desc":"Lorem ipsum dolor sit amet, consectetur\nLorem ipsum dolor sit amet, consectetur","date":"11 January"],["title":"Lorem ipsum dolor sit amet","desc":"Lorem ipsum dolor sit amet, consectetur\nLorem ipsum dolor sit amet, consectetur","date":"11 January"]]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        hideNavbar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 142.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "NotificationCardTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationCardTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyNotificationsCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCardTableViewCell", for: indexPath) as? NotificationCardTableViewCell
            cell?.notificationTitleLabel.text = notifications[indexPath.row-1]["title"] as! String
            cell?.notificationDateLabel.text = notifications[indexPath.row-1]["date"] as! String
            cell?.notificationMsgLabel.text = notifications[indexPath.row-1]["desc"] as! String
            cell?.selectionStyle = .none
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "NotificationDetailsViewController") as? NotificationDetailsViewController
            vc!.notificationDetails = notifications[indexPath.row-1]
            vc!.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    

}
