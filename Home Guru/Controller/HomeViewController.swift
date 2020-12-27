//
//  HomeViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 03/12/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: Constants.isRegistered) != nil{
            self.tabBarController?.tabBar.isHidden = UserDefaults.standard.bool(forKey: Constants.isRegistered)
        }
    }


}
