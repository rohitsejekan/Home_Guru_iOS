//
//  SelectScheduleViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 16/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit

class SelectScheduleViewController: UIViewController {

    @IBOutlet weak var nextBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goNext(_ sender: Any) {
        let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "ConfirmSchedule") as! ConfirmScheduleViewController
        //setNavigationBackTitle(title: "Schedule")
        vc.hidesBottomBarWhenPushed = true
         presentDetail(vc)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
