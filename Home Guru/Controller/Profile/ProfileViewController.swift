//
//  ProfileViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 20/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import SwiftyJSON
import NVActivityIndicatorView
class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ProfileEditProtocol {
//com.googleusercontent.apps.775623820148-vpltqjq0qqaitfaa93gt73ebjd81jvqc
    

    @IBOutlet weak var activityLoaderView: NVActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var profileFields : [String] = ["Account","Wallet","Contact Us","Signout"]
    var studentName: String = ""
    var studentStd: String = ""
    var studentDob: String = ""
    var window: UIWindow?
    var childrenDetails = [myChildren]()
    var indexValue: Int?
    var imageRunOnce: Int = 0
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       // hideNavbar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // refresh editing
         NotificationCenter.default.addObserver(self, selector: #selector(self.refreshCancel), name: NSNotification.Name(rawValue: "refreshEditing"), object: nil)
        
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "ProfileCardTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileCardTableViewCell")
        getprofile()
        
        //refresh profile screen
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshProfile), name: NSNotification.Name(rawValue: "refreshProfile"), object: nil)
        
    }
    @objc func refreshProfile(){
       // print("index1...\(indexValue)")
                if !childrenDetails.isEmpty{
        //            print("selected id..\(arr[index]._id)")
                    UserDefaults.standard.set(childrenDetails[indexValue!]._id, forKey: "studentId")
                   // print("stu id....\(UserDefaults.standard.string(forKey: "studentId"))")
                    studentName = childrenDetails[indexValue!].name
                    //studentStd = "CLASS - " + arr[index].stdClass
                    studentDob = childrenDetails[indexValue!].dob
                    tableView.reloadData()
                }
        

    }
    @objc func refreshCancel() {

       self.getprofile() // a refresh the tableView.

       }
    private func getprofile(){
        self.activityLoaderView.startAnimating()
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
                                        if !self.childrenDetails.isEmpty{
                                            self.childrenDetails.removeAll()
                                        }
                                        for arr in val["student"].arrayValue{
                                            self.childrenDetails.append(myChildren(json: arr))
                                            self.studentName = arr["name"].stringValue
                                            StructOperation.glovalVariable.studentId = arr["_id"].stringValue
                                            self.studentStd = arr["stdClass"].stringValue
                                            self.studentDob = arr["dob"].stringValue
                                            
                                        }
                                        for arr1 in val["residentalAddress"].arrayValue{
                                            print("..q\(arr1["house_no"].stringValue)")
                                            StructOperation.glovalVariable.address = arr1["house_no"].stringValue
                                        }
                                        print("mychildren...\(self.childrenDetails)")
                                   DispatchQueue.main.async {
                                    self.activityLoaderView.stopAnimating()
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
            if imageRunOnce == 0{
                cell.profileImage.image = imageWithGradient(img: cell.profileImage.image)
                imageRunOnce = 1
                
            }
            
           // cell!.profileEditDelegate = self
            cell.delegate = self

            cell.configure(with: self.childrenDetails)
            cell.studentNameLabel.text = studentName
           // cell.classLabel.text = "CLASS - " + studentStd
            cell.dobDetailsLabel.text = "DOB - " + studentDob
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
            let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to logout", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                UserDefaults.standard.set(false, forKey: Constants.loginStatus)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let rootVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = rootVC
                

                print("....logout...")
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        default:
            print(".....")
        }
    }
    
    func editProfile(index: Int) {
        // navigate to edit profile
    let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "editProfileViewController") as! editProfileViewController
        vc.updateDelegate = self
        vc.editDetails["name"] = studentName
        vc.studentDates = studentDob
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func addProfile() {
           let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "addProfile") as? addProfileViewController
                 vc!.hidesBottomBarWhenPushed = true
                 self.present(vc!, animated: true, completion: nil)
    }
    
}
extension ProfileViewController: updateProfile{
    func updateP() {
        //getprofile()
    }
}
extension ProfileViewController{
    func switchProfile(index: Int) {
        indexValue = index
        print("index..\(index)")
         let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "profileSwitchViewController") as? profileSwitchViewController
                   vc!.hidesBottomBarWhenPushed = true
        vc!.studentName = studentName
        vc!.studentDob = studentDob
        vc!.index = index
                   self.navigationController?.pushViewController(vc!, animated: true)
    }
}
