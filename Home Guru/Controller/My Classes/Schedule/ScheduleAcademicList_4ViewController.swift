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
class ScheduleAcademicList_4ViewController: UIViewController,IndicatorInfoProvider,UITableViewDataSource, UITableViewDelegate {
    var academicSubjectList : [[String:Any]] = [["title":"Class 1"],["title":"Class 2"],["title":"Class 3"],["title":"Class 4"],["title":"Class 5"],["title":"Class 6"],["title":"Class 7"],["title":"Class 8"]]
            var childNumber = ""
            var index : Int = 0
    @IBOutlet weak var backBtn: UIButton!
    var rowsWhichAreChecked = [NSIndexPath]()
    var checkedCount: Int = 0
    var checkedName: [String] = []
    var subjectId: String = ""
    var subjectDetails: [String: String] = [:]
    var getSubjects = [GetSubjects]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
               tableView.register(UINib(nibName: "ScheduleSubject_4TableViewCell", bundle: nil), forCellReuseIdentifier: "ScheduleSubject_4")
        
         tableView.register(UINib(nibName: "customButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "customButton")
        // Do any additional setup after loading the view.
        
        backBtn.layer.cornerRadius = 5
        getGroupCat()
    }
    func getGroupCat(){
                   subjectDetails["groupId"] = subjectId
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
                                self.getSubjects.append(GetSubjects(json: arr))
                                   print("child sub...\(arr)")
                                
                                   
                               }
                                print("get sub...\(self.getSubjects)")
                                                     
                           DispatchQueue.main.async {
                            for _ in 0..<(self.getSubjects.count){
                                self.checkedName.append("")
                                
                            }
                            print("checkedName...\(self.checkedName)")
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
       // self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
            return IndicatorInfo(title: "\(childNumber)")
        }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected.....\(indexPath.row)")
         let cell = tableView.cellForRow(at: indexPath) as! ScheduleSubject_4TableViewCell
               cell.checked = !cell.checked
        if cell.checked == true{
            checkedCount = checkedCount + 1
            //checkedName.append(cell.labelName.text ?? "")
            checkedName.insert(cell.labelName.text ?? "", at: indexPath.row)
            print("checked count....\(checkedCount)")
            print("checked name...\(checkedName)")
        }else{
            if checkedCount > 0{
                checkedCount = checkedCount - 1
                checkedName.remove(at: indexPath.row)
                print("unchecked count....\(checkedCount)")
                print("unchecked name...\(checkedName)")
            }
            
        }
        tableView.reloadData()
    }
          func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
              return getSubjects.count + 1
          }
          func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.row == getSubjects.count{
                return 100
            }else{
                return 75
            }
              
          }
          func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ScheduleAcademicList_4ViewController: nextScreen{
    func gotoScreen() {
        let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "ScheduleDurationTime") as! ScheduleDurationTimeViewController
                                       //setNavigationBackTitle(title: "Schedule")
                vc.hidesBottomBarWhenPushed = true
        vc.selectedCounts = checkedCount
        vc.getCheckedName = checkedName
    self.navigationController?.pushViewController(vc, animated: false)

    }
    
    
}
