//
//  ProfileViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 20/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import SwiftyJSON
class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ProfileEditProtocol {

    @IBOutlet weak var tableView: UITableView!
    var profileFields : [String] = ["Account","Wallet","Contact Us","Signout"]
    var studentName: String = ""
    var studentStd: String = ""
    var studentDob: String = ""
    var childrenDetails = [myChildren]()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       // hideNavbar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "ProfileCardTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileCardTableViewCell")
        getprofile()
        
        
    }
    private func getprofile(){
        AlamofireService.alamofireService.getRequestWithToken(url: URLManager.sharedUrlManager.getProfile, parameters: nil) {
                           response in
                              switch response.result {
                              case .success(let value):
                                  if let status =  response.response?.statusCode {
                                  print("guru p ..\(status)")
                                   print("g p...\(value)")
                                      if status == 200 || status == 201 {
                                   let val = JSON(value)
                                      print("val ...\(val)")
                                        for arr in val["student"].arrayValue{
                                            self.childrenDetails.append(myChildren(json: arr))
                                            self.studentName = arr["name"].stringValue
                                            self.studentStd = arr["stdClass"].stringValue
                                            self.studentDob = arr["dob"].stringValue
                                        }
                                        print("mychildren...\(self.childrenDetails)")
                                   DispatchQueue.main.async {
                                  
                                       self.tableView.reloadData()
                                    }
                                                         }
                                  }
                              case .failure( _):
                                  print("failure")
                                       return
                                   }
                              }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileFields.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCardTableViewCell", for: indexPath) as! ProfileCardTableViewCell
            cell.profileImage.image = imageWithGradient(img: cell.profileImage.image)
           // cell!.profileEditDelegate = self
            cell.delegate = self

            if !childrenDetails.isEmpty{
                print("my..\(childrenDetails.count)")
                cell.myChildrenCount = childrenDetails.count
                //cell.myChildrens = childrenDetails
            }
            cell.configure(with: self.childrenDetails)
            cell.studentNameLabel.text = studentName
            cell.classLabel.text = "CLASS - " + studentStd
            cell.dobDetailsLabel.text = studentDob
            cell.selectionStyle = .none
            return cell
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
            UserDefaults.standard.set(false, forKey: Constants.loginStatus)
            print("....logout...")
        default:
            print(".....")
        }
    }
    
    func editProfile(index: Int) {
        // navigate to edit profile
    let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "editProfileViewController") as! editProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func addProfile() {
           let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "addProfile") as? addProfileViewController
                 vc!.hidesBottomBarWhenPushed = true
                 self.present(vc!, animated: true, completion: nil)
    }
    
    

}

