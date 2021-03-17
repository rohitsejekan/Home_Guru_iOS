//
//  addProfileViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 16/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit

class addProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var addProfileTV: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "addProfile", for: indexPath) as! addProfileTableViewCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "customButton", for: indexPath) as! customButtonTableViewCell
            cell.goToDelegate = self
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            return 70
        }else{
            return UITableView.automaticDimension
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addProfileTV.estimatedRowHeight = UITableView.automaticDimension
        addProfileTV.rowHeight = 300
        
        // add custom button
        
        addProfileTV.register(UINib(nibName: "customButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "customButton")
    }
    

    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
extension addProfileViewController: nextScreen{
    func gotoScreen() {
    print("button pressed")
    }
    
    
}
