//
//  ProfileViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 20/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, ProfileEditProtocol {

    @IBOutlet weak var tableView: UITableView!
    var profileFields : [String] = ["Account","Wallet","Contact Us","Signout"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        hideNavbar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "ProfileCardTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileCardTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileFields.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCardTableViewCell", for: indexPath) as? ProfileCardTableViewCell
            cell!.delegate = self
            cell!.selectionStyle = .none
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCell", for: indexPath) as? ProfileInfoTableViewCell
            cell?.titleLabel.text = profileFields[indexPath.row-1]
            cell?.selectionStyle = .none
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "AccountViewController") as? AccountViewController
            vc!.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc!, animated: true)
        case 2:
            let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "WalletViewController") as? WalletViewController
            vc!.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc!, animated: true)
        case 3:
            let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "ContactUsViewController") as? ContactUsViewController
            vc!.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc!, animated: true)
        case 4:
            // code for logout
            print("....logout...")
        default:
            print(".....")
        }
    }
    
    func editProfile(index: Int) {
        // navigate to edit profile
    }
    
    func addProfile() {
        // navigate to add profile screen
    }
    
    

}

