//
//  MyGurusViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 10/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit

class MyGurusViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var myGurus : [[String:Any]] = [[:],[:],[:],[:],[:],[:]]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        hideNavbar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "MyGuruCard", bundle: nil), forCellReuseIdentifier: "MyGuruCard")
    }
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let hide = (viewController is NotificationsViewController)
        navigationController.setNavigationBarHidden(hide, animated: animated)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGurus.count + 1
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyGuruHeaderCell", for: indexPath)
            cell.selectionStyle = .none
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyGuruCard", for: indexPath) as? MyGuruCard
            cell?.selectionStyle = .none
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "MyGuruDetailsViewController") as! MyGuruDetailsViewController
            vc.myGurusDetails = myGurus[indexPath.row-1]
            vc.hidesBottomBarWhenPushed = true

       self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    

}
