//
//  currentBookingViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 25/04/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import XLPagerTabStrip
import NVActivityIndicatorView
import Kingfisher
class currentBookingViewController: UIViewController ,IndicatorInfoProvider{
  
    var norecord: Bool?
    @IBOutlet weak var activityLoaderView: NVActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var bookingStatus = [String: String]()
    var currentBook = [currentPastBooking]()
    var childNumber = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // custom cell
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableView.automaticDimension
        // custom cell
        tableView.register(UINib(nibName: "currentPastBookingTableViewCell", bundle: nil), forCellReuseIdentifier: "currentPastCell")
        // custom userupdate cell
        tableView.register(UINib(nibName: "userUpdateTableViewCell", bundle: nil), forCellReuseIdentifier: "userUpdate")
        currentBooking()
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
          return IndicatorInfo(title: "\(childNumber)")
      }
    override var preferredStatusBarStyle : UIStatusBarStyle {
         return UIStatusBarStyle.default
     }
    
    func gotoNorecord(){
        if let id = UserDefaults.standard.string(forKey: "studentId"){
                   
                   activityLoaderView.startAnimating()
                          bookingStatus["studentId"] = id
                          bookingStatus["type"] = "current"
                   AlamofireService.alamofireService.postRequestWithBodyDataAndToken(url: URLManager.sharedUrlManager.currentBooking, details: bookingStatus) {
                               response in
                               switch response.result {
                               case .success(let value):
                                   if let status =  response.response?.statusCode {
                                       print("status is ..\(status)")
                                       if status == 200 || status == 201 {
                                           let val = JSON(value)
                                           self.norecord = true
                                           print("valbook...\(val)")
                                         
                                           DispatchQueue.main.async {
                                               self.activityLoaderView.stopAnimating()
                                               self.tableView.reloadData()
                                               print("booking...\(self.currentBook)")
                                           }
                                       } else {
                                           print("failure 402")
                                       }
                                   }
                               case .failure( _):
                                   
                                   print("failure")
                                   
                               }
                           }
                   
               }
              
    }

    func currentBooking(){
        if let id = UserDefaults.standard.string(forKey: "studentId"){
            
            activityLoaderView.startAnimating()
                   bookingStatus["studentId"] = id
                   bookingStatus["type"] = "current"
            AlamofireService.alamofireService.postRequestWithBodyDataAndToken(url: URLManager.sharedUrlManager.currentBooking, details: bookingStatus) {
                        response in
                        switch response.result {
                        case .success(let value):
                            if let status =  response.response?.statusCode {
                                print("status is ..\(status)")
                                if status == 200 || status == 201 {
                                    let val = JSON(value)
                                    self.norecord = false
                                    print("valbook...\(val)")
                                    for arr in val.arrayValue{
                                        self.currentBook.append(currentPastBooking(json: arr))
                                    }
                                    DispatchQueue.main.async {
                                        self.activityLoaderView.stopAnimating()
                                        self.tableView.reloadData()
                                        print("booking...\(self.currentBook)")
                                    }
                                } else {
                                    print("failure 400")
                                }
                            }
                        case .failure( _):
                            self.activityLoaderView.stopAnimating()
                            self.gotoNorecord()
                            print("failure1")
                            
                        }
                    }
            
        }
       

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

extension currentBookingViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if norecord == false{
            return currentBook.count
        }else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if norecord == false{
            let cell = tableView.dequeueReusableCell(withIdentifier: "currentPastCell", for: indexPath) as! currentPastBookingTableViewCell
            cell.containerView.layer.cornerRadius = 7
                  cell.subjectName.text = currentBook[indexPath.row].subject[0].subjectName
                  cell.facultyName.text = currentBook[indexPath.row].faculty?.name
                  cell.scheduleDate.text = currentBook[indexPath.row].date
            cell.facultyImage.layer.cornerRadius = 25
            cell.selectionStyle = .none
            
            if let img = currentBook[indexPath.row].faculty?.profilePic?.image_url{
                print("img...\(img)")
                if img == ""{
                    cell.facultyImage.image = UIImage(named: "facultyPlaceholder")
                }else{
                    //cell.facultyImage.image = UIImage(named: "\(img)")
                    let url = URL(string: "\(img)")
                    cell.facultyImage.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
                    
                }
            }
            
                  return cell
        }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "userUpdate", for: indexPath) as! userUpdateTableViewCell
            cell.selectionStyle = .none
                return cell
        }
      
    }
    
    
}
