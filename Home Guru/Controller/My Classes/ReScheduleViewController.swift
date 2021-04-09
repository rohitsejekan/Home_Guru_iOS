//
//  ReScheduleViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 08/04/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit
class ReScheduleViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource ,UIPickerViewDataSource, UIPickerViewDelegate{
 
    
    @IBOutlet weak var pickerView2: UIPickerView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var outerPickerView: UIView!
    var boards: [String] = ["class 1","class 10","class 1","class 1","class 1"]
     var classes: [String] = ["class 1","class 2","class 3","class 4","class 5", "class 6", "class 7", "class 8", "class 9", "class 10", "class 11", "class 12"]

    @IBOutlet weak var outerPickerView2: UIView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView2.delegate = self
        pickerView2.dataSource = self
        outerPickerView.isHidden = true
        outerPickerView2.isHidden = true
    }
    
    @IBAction func dismissPV1(_ sender: UIBarButtonItem) {
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
               hideUnhidePickerView(view: self.outerPickerView, value: true)
        reload(tableView: self.tableView)
        print("clicked")
    }
    @IBAction func dismissPV2(_ sender: UIBarButtonItem) {
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
               hideUnhidePickerView(view: self.outerPickerView2, value: true)
        reload(tableView: self.tableView)
    }
    func reload(tableView: UITableView) {

           let contentOffset = tableView.contentOffset
           tableView.reloadData()
           tableView.layoutIfNeeded()
           tableView.setContentOffset(contentOffset, animated: false)

       }
    @IBAction func selectDays(_ sender: UIButton) {
        if outerPickerView2.isHidden{
                  outerPickerView2.isHidden = false
              }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
   }
   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       if pickerView == pickerView2{
           return classes.count

       }else{
           return boards.count
       }
   }
   func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
   {
       if pickerView == pickerView2{
            return classes[row]
       }else{
           
           return boards[row]
       }
       
   }
   func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       if pickerView == pickerView2{
            print("\(classes[row])")
           
       }else{
          print("\(classes[row])")
       }
           
  }
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 1
     }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "ReSchedule") as! ReScheduleTableViewCell
        cell.goNextPage.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        cell.goNextPage.tag = indexPath.row
        cell.selectionStyle = .none

         return cell
     }
    @objc func connected(sender: UIButton){
//        let buttonTag = sender.tag
           let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "SelectSchedule") as! SelectScheduleViewController
           //setNavigationBackTitle(title: "Schedule")
           vc.hidesBottomBarWhenPushed = true
          
        
           self.navigationController?.pushViewController(vc, animated: false)

    }
}
