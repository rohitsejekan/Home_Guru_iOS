//
//  NotificationDetailsViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 20/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit

class NotificationDetailsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var tableView: UITableView!
    var notificationDetails : [String:Any] = [:]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        hideNavbar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 440.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "NotificationDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationDetailTableViewCell")
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationDetailTableViewCell", for: indexPath) as? NotificationDetailTableViewCell
        cell?.selectionStyle = .none
        return cell!
    }
    

}
