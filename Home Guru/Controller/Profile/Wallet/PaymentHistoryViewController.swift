//
//  PaymentHistoryViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 20/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import SwiftyJSON
class PaymentHistoryViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var transitionHistory = [TransactionHistory]()
    var transactionList : [[String:Any]] = [["id":"Ref No : 1951621684953561","date":"09/ 04 / 2020","amount":"+500"],["id":"Ref No : 1951621684953561","date":"09/ 04 / 2020","amount":"-500"],["id":"Ref No : 1951621684953561","date":"09/ 04 / 2020","amount":"+500"],["id":"Ref No : 1951621684953561","date":"09/ 04 / 2020","amount":"-500"],["id":"Ref No : 1951621684953561","date":"09/ 04 / 2020","amount":"+500"],["id":"Ref No : 1951621684953561","date":"09/ 04 / 2020","amount":"-500"]]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        hideNavbar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 86.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "NotificationCardTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationCardTableViewCell")
        //back button
        backBtn.layer.cornerRadius = 5
        getpaymentHistory()
    }
    
    func getpaymentHistory(){
        AlamofireService.alamofireService.getRequestWithToken(url: URLManager.sharedUrlManager.transcation, parameters: nil) {
                  response in
                  switch response.result {
                  case .success(let value):
                      if let status =  response.response?.statusCode {
                          print("status is ..\(status)")
                          if status == 200 || status == 201 {
                            let json = JSON(value)
                            print("value....\(json)")
                            for arr in json.arrayValue{
                                print("v.....\(arr["points"])")
                                self.transitionHistory.append(TransactionHistory(json:arr))
                            }
                              DispatchQueue.main.async {
                                self.tableView.reloadData()
                                print("....\(response.result)")
                              }
                          }
                      }
                  case .failure( _):
                      print("failure")
                  }
              }
    }
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transitionHistory.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !transitionHistory.isEmpty{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentHistoryTableViewCell", for: indexPath) as? PaymentHistoryTableViewCell
            cell?.transactionIdLabel.text = transitionHistory[indexPath.row]._id
            cell?.dateLabel.text = transitionHistory[indexPath.row].dates
            cell?.amountLabel.text = transitionHistory[indexPath.row].points
            cell?.amountLabel.textColor = indexPath.row % 2 == 0 ? ColorPalette.whiteColor : ColorPalette.redColor
            cell?.selectionStyle = .none
            return cell!
        }else{
            return UITableViewCell()
        }
        
    }


}
