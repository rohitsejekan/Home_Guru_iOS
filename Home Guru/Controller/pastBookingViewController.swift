//
//  pastBookingViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 25/04/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit
import SwiftyJSON
import XLPagerTabStrip
import Alamofire
import NVActivityIndicatorView
class pastBookingViewController: UIViewController,IndicatorInfoProvider {
    var itemInfo = IndicatorInfo(title: "Your tab title here")
   var bookingStatus = [String: String]()
    var pastBook = [currentPastBooking]()
    var childNumber = ""
  
    @IBOutlet weak var activityLoaderView: NVActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

         // custom cell
             tableView.register(UINib(nibName: "currentPastBookingTableViewCell", bundle: nil), forCellReuseIdentifier: "currentPastCell")
             // custom userupdate cell
             tableView.register(UINib(nibName: "userUpdateTableViewCell", bundle: nil), forCellReuseIdentifier: "userUpdate")
        // Do any additional setup after loading the view.
        pastBooking()
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
          return IndicatorInfo(title: "\(childNumber)")
      }
    override var preferredStatusBarStyle : UIStatusBarStyle {
            return UIStatusBarStyle.default
        }
    func pastBooking(){
        activityLoaderView.startAnimating()
//        bookingStatus["studentId"] = StructOperation.glovalVariable.studentId
        bookingStatus["studentId"] = "2"

              bookingStatus["type"] = "past"
              AlamofireService.alamofireService.postRequestWithBodyDataAndToken(url: URLManager.sharedUrlManager.currentBooking, details: bookingStatus) {
                          response in
                          switch response.result {
                          case .success(let value):
                              if let status =  response.response?.statusCode {
                                  print("status is ..\(status)")
                                  if status == 200 || status == 201 {
                                      let val = JSON(value)
                                      print("val...\(val)")
                                    for arr in val.arrayValue{
                                    self.pastBook.append(currentPastBooking(json: arr))
                                                                  }
                                      DispatchQueue.main.async {
                                        print("past book....\(self.pastBook)")
                                        self.activityLoaderView.stopAnimating()
                                        self.tableView.reloadData()
                                      }
                                  } else {
                                      print("failure")
                                  }
                              }
                          case .failure( _):
                              print("failure")
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

extension pastBookingViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !pastBook.isEmpty{
            return pastBook.count
        }else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !pastBook.isEmpty{
            let cell = tableView.dequeueReusableCell(withIdentifier: "currentPastCell", for: indexPath) as! currentPastBookingTableViewCell
                  cell.subjectName.text = pastBook[indexPath.row].subject[0].subjectName
                  cell.facultyName.text = pastBook[indexPath.row].faculty?.name
                  cell.scheduleDate.text = pastBook[indexPath.row].date
                  return cell
        }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "userUpdate", for: indexPath) as! userUpdateTableViewCell
                return cell
        }
      
    }
    
    
}
