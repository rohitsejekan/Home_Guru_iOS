//
//  ScheduleAcademicList_4ViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 12/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
import NVActivityIndicatorView
import JJFloatingActionButton
class ScheduleAcademicList_4ViewController: UIViewController,IndicatorInfoProvider,UITableViewDataSource, UITableViewDelegate {
    var academicSubjectList : [[String:Any]] = [["title":"Class 1"],["title":"Class 2"],["title":"Class 3"],["title":"Class 4"],["title":"Class 5"],["title":"Class 6"],["title":"Class 7"],["title":"Class 8"]]
            var childNumber = ""
            var index : Int = 0
    let actionButton = JJFloatingActionButton()
    @IBOutlet weak var activityLoaderView: NVActivityIndicatorView!
    // store label
    var checkedName: [String] = []
    var groupDetails: [String: String] = [:]
    // store index value
    var subId: [String] = []
    var array = [Int]()
    @IBOutlet weak var backBtn: UIButton!
    var rowsWhichAreChecked = [NSIndexPath]()
    var checkedCount: Int = 0
    var norecord: Bool?
    var subjectId: String = ""
    var subjectDetails: [String: Any] = [:]
    var getSubjects = [GetSubjects]()
    var popToVC: Bool = false
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //floating button
        floatingButton()
        actionButton.buttonDiameter = 65
        actionButton.buttonImageSize = CGSize(width: 35, height: 35)
        //floating button ends
               tableView.register(UINib(nibName: "ScheduleSubject_4TableViewCell", bundle: nil), forCellReuseIdentifier: "ScheduleSubject_4")
        
         tableView.register(UINib(nibName: "customButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "customButton")
        // Do any additional setup after loading the view.
        // custom userupdate cell
               tableView.register(UINib(nibName: "userUpdateTableViewCell", bundle: nil), forCellReuseIdentifier: "userUpdate")
        backBtn.layer.cornerRadius = 5
        getGroupCat()
    }
    func getGroupCat(){
        activityLoaderView.startAnimating()
                   subjectDetails["groupId"] = [subjectId]
        print("sad....\(subjectId)")
           //        parentDetails["mobileNo"] = UserDefaults.standard.string(forKey: Constants.mobileNo)
                   AlamofireService.alamofireService.postRequestWithBodyData(url: URLManager.sharedUrlManager.getSubjects, details: subjectDetails) {
                   response in
                      switch response.result {
                      case .success(let value):
                          if let status =  response.response?.statusCode {
                          print("status issw ..\(status)")
                           print("value...\(value)")
                              if status == 200 || status == 201 {
                           let val = JSON(value)
                               for arr in val.arrayValue{
                                self.norecord = false
                                self.getSubjects.append(GetSubjects(json: arr))
                                   print("child sub...\(arr)")
                                
                                   
                               }
                                print("get sub...\(self.getSubjects)")
                                                     
                           DispatchQueue.main.async {
                          self.activityLoaderView.stopAnimating()
                               self.tableView.reloadData()
                            }
                                                 }
                          }
                      case .failure( _):
                          print("failure")
                          self.getGroupCat(id: self.subjectId)
                               return
                           }
                      }
       }
    func getGroupCat(id: String){
        activityLoaderView.startAnimating()
                groupDetails["categoryid"] = id
        //UserDefaults.standard.set("\(id)", forKey: "groupId")
        //        parentDetails["mobileNo"] = UserDefaults.standard.string(forKey: Constants.mobileNo)
                AlamofireService.alamofireService.postRequestWithBodyDataString(url: URLManager.sharedUrlManager.groupChildCategory, details: groupDetails) {
                response in
                   switch response.result {
                   case .success(let value):
                       if let status =  response.response?.statusCode {
                       print("status is ..\(status)")
                        print("value...\(value)")
                           if status == 200 || status == 201 {
                        let val = JSON(value)
                            self.norecord = true
                                print("output...\(val)")
                      
                        
                                                  
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
    @IBAction func goBack(_ sender: Any) {
        if popToVC == true{
            // self.dismiss(animated: true, completion: nil)
             let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "ScheduleAcademicList_2") as! ScheduleAcademicList_2ViewController
            self.navigationController?.popToViewController(vc, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
       
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
            return IndicatorInfo(title: "\(childNumber)")
        }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < getSubjects.count{
            print("selected.....\(indexPath.row)")
                    let cell = tableView.cellForRow(at: indexPath) as! ScheduleSubject_4TableViewCell
                          cell.checked = !cell.checked
                   if cell.checked == true{
                       checkedCount = checkedCount + 1
                       checkedName.append(getSubjects[indexPath.row].title)
                       subId.append(getSubjects[indexPath.row]._id)
                       array.append(indexPath.row)
                       print("checked count....\(checkedCount)")
                       print("checked name...\(array)")
                       print("subject name...\(subId)")
                       print("name...\(checkedName)")
                   }else{
                       if checkedCount > 0{
                            checkedCount = checkedCount - 1
                            let index = array.firstIndex(of: indexPath.row) ?? 0
                           array.remove(at: index)
                           checkedName.remove(at: index)
                           subId.remove(at: index)
                           print("unchecked count....\(checkedCount)")
                           print("unchecked name...\(array)")
                           print("unchecked subject id...\(subId)")
                           print("name...\(checkedName)")
                       }
                       
                   }
                   tableView.reloadData()
        }
       
    }
          func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if norecord == false{
                return getSubjects.count + 1
            }else{
                return 1
            }
              
          }
          func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            switch norecord{
            case false:
                if indexPath.row == getSubjects.count{
                    return 100
                }else{
                    return 75
                }
            case true:
                return 120
            default:
                return 100
            }
            
              
          }
          func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            switch norecord{
            case false:
                if indexPath.row < getSubjects.count {
                                  let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleSubject_4", for: indexPath) as? ScheduleSubject_4TableViewCell
                               cell?.labelName.text = getSubjects[indexPath.row].title
                             
                                       cell?.selectionStyle = .none
                                     cell?.preservesSuperviewLayoutMargins = false
                                     cell?.separatorInset = .zero
                                     cell?.layoutMargins = .zero
                           
                               //        cell?.radioImageView.image = UIImage(named: indexPath.row == index ? "radioSelected" : "radioUnselected")
                                     
                                       return cell!
                           }else{
                                let cell = tableView.dequeueReusableCell(withIdentifier: "customButton", for: indexPath) as! customButtonTableViewCell
                               cell.goToDelegate = self
                               return cell
                           }
            case true:
                let cell = tableView.dequeueReusableCell(withIdentifier: "userUpdate", for: indexPath) as! userUpdateTableViewCell
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "userUpdate", for: indexPath) as! userUpdateTableViewCell
                return cell
                    
        }
                
            }
           
          
//          func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//              index = indexPath.row
//            let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "ScheduleDurationTime") as! ScheduleDurationTimeViewController
//                               //setNavigationBackTitle(title: "Schedule")
//                               vc.hidesBottomBarWhenPushed = true
//                               self.present(vc, animated: true, completion: nil)
//              DispatchQueue.main.async {
//                  self.tableView.reloadData()
//              }
//          }
    

}
extension ScheduleAcademicList_4ViewController: nextScreen{
    func gotoScreen() {
        let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "ScheduleDurationTime") as! ScheduleDurationTimeViewController
                                       //setNavigationBackTitle(title: "Schedule")
                vc.hidesBottomBarWhenPushed = true
        vc.selectedCounts = checkedCount
        vc.getCheckedName = checkedName
       
        vc.studentDetails = [[String:Any]](repeating: [String : Any](), count: checkedCount)
        UserDefaults.standard.set(subId, forKey: "subjectId")
        UserDefaults.standard.set(checkedName, forKey: "checkedName")
       // StructOperation.glovalVariable.studentId = subjectId
        print("idii id.....\( UserDefaults.standard.object(forKey: "subjectId"))")
       
    self.navigationController?.pushViewController(vc, animated: false)

    }
    
    
}
extension ScheduleAcademicList_4ViewController{
    func floatingButton(){
              actionButton.addItem(title: "whatsApp", image: UIImage(named: "whatsApp")?.withRenderingMode(.alwaysTemplate)) { item in
              
                         
                         if let whatsappURL = URL(string: "https://api.whatsapp.com/send?phone=+919001990019&text=Invitation"), UIApplication.shared.canOpenURL(whatsappURL) {
                                        if #available(iOS 10, *) {
                                            UIApplication.shared.open(whatsappURL)
                                        } else {
                                            UIApplication.shared.openURL(whatsappURL)
                                        }
                         }
                     }

                     actionButton.addItem(title: "call", image: UIImage(named: "mdi_call")?.withRenderingMode(.alwaysTemplate)) { item in
                       // do something
                   if let url = URL(string: "tel://\(Constants.contactUs)"), UIApplication.shared.canOpenURL(url) {
                                      if #available(iOS 10, *) {
                                          UIApplication.shared.open(url)
                                      } else {
                                          UIApplication.shared.openURL(url)
                                      }
                                  }
                     }

                     actionButton.buttonImage = UIImage(named: "customer-service")
                     actionButton.buttonColor = ColorPalette.homeGuruDarkGreyColor
                     view.addSubview(actionButton)
                     actionButton.translatesAutoresizingMaskIntoConstraints = false
                     if #available(iOS 11.0, *) {
                         actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
                     } else {
                         // Fallback on earlier versions
                         actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
                     }
                     if #available(iOS 11.0, *) {
                         actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
                     } else {
                         // Fallback on earlier versions
                         actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
                     }
          }
          
}
