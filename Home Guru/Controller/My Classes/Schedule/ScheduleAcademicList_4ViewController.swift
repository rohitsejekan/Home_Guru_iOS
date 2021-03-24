//
//  ScheduleAcademicList_4ViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 12/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ScheduleAcademicList_4ViewController: UIViewController,IndicatorInfoProvider,UITableViewDataSource, UITableViewDelegate {
    var academicSubjectList : [[String:Any]] = [["title":"Class 1"],["title":"Class 2"],["title":"Class 3"],["title":"Class 4"],["title":"Class 5"],["title":"Class 6"],["title":"Class 7"],["title":"Class 8"]]
            var childNumber = ""
            var index : Int = 0
    @IBOutlet weak var backBtn: UIButton!
    var rowsWhichAreChecked = [NSIndexPath]()
    var checkedCount: Int = 0
    var checkedName: [String] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
               tableView.register(UINib(nibName: "ScheduleSubject_4TableViewCell", bundle: nil), forCellReuseIdentifier: "ScheduleSubject_4")
        
         tableView.register(UINib(nibName: "customButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "customButton")
        // Do any additional setup after loading the view.
        
        backBtn.layer.cornerRadius = 5
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
            checkedName.append(cell.labelName.text ?? "")
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
              return academicSubjectList.count + 1
          }
          func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.row == academicSubjectList.count{
                return 100
            }else{
                return 75
            }
              
          }
          func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.row < academicSubjectList.count {
                   let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleSubject_4", for: indexPath) as? ScheduleSubject_4TableViewCell
                        cell?.labelName.text = academicSubjectList[indexPath.row]["title"] as? String
              
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
    self.navigationController?.pushViewController(vc, animated: false)

    }
    
    
}
