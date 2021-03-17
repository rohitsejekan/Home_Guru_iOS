//
//  ConfirmScheduleViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 15/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit

class ConfirmScheduleViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        tableView.estimatedRowHeight = 142.0
        tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
        // custom button
         tableView.register(UINib(nibName: "customButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "customButton")
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "confirmSheduleFirst", for: indexPath) as!
            confirmSheduleFirstTableViewCell
            DispatchQueue.main.async {
                cell.datesCV.reloadData()
            }
              return cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmScheduleSecond", for: indexPath) as! ConfirmScheduleSecondTableViewCell
                    return cell
        }else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "confirmScheduleThird", for: indexPath) as! confirmScheduleThirdTableViewCell
                               return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "customButton", for: indexPath) as! customButtonTableViewCell
            cell.goToDelegate = self
            return cell
        }
  
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3{
            return 90
        }else{
            return UITableView.automaticDimension
        }
        
    }

}
extension ConfirmScheduleViewController: nextScreen{
    func gotoScreen() {
   self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
}
