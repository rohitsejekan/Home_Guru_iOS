//
//  ScheduleAcademicList_5ViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 26/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit
import SwiftyJSON
import JJFloatingActionButton
class ScheduleAcademicList_5ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let actionButton = JJFloatingActionButton()
    @IBOutlet weak var tableView: UITableView!
    var subjectBoardId: String = ""
    var storeBoard: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //floating button
        floatingButton()
        tableView.register(UINib(nibName: "ScheduleSubject_2TableViewCell", bundle: nil), forCellReuseIdentifier: "ScheduleSubject_2")
        // Do any additional setup after loading the view.
        getBoards()
    }
    func getBoards(){
         AlamofireService.alamofireService.getRequest(url: URLManager.sharedUrlManager.getBoards, parameters: nil) { response
                     in
                     switch response.result {
                     case .success(let value):
                         if let status =  response.response?.statusCode {
                             print("svis ..\(value)")
                             print("sstatus is ..\(status)")
                             if status == 200 || status == 201 {
                                 let json = JSON(value)
                                 for arr in json.arrayValue{
                                     self.storeBoard.append(arr["name"].stringValue)
                                     
                                 }

                                 print("data...\(self.storeBoard)")
                                 DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                 }
                             }
                         }
                     case .failure( _):
                         print("failure")
                     }
                 }
     }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeBoard.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "ScheduleAcademicList_4") as! ScheduleAcademicList_4ViewController
                               //setNavigationBackTitle(title: "Schedule")
                               vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: false)
            vc.subjectId = subjectBoardId
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleSubject_2", for: indexPath) as? ScheduleSubject_2TableViewCell
        cell?.sub_2Name.text = storeBoard[indexPath.row]
                cell?.selectionStyle = .none
                cell?.preservesSuperviewLayoutMargins = false
                      cell?.separatorInset = .zero
                      cell?.layoutMargins = .zero
        //        cell?.radioImageView.image = UIImage(named: indexPath.row == index ? "radioSelected" : "radioUnselected")
              
                return cell!
    }

    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
extension ScheduleAcademicList_5ViewController{
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

                     actionButton.buttonImage = UIImage(named: "profile")
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
