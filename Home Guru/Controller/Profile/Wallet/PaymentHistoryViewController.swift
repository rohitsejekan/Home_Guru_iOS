//
//  PaymentHistoryViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 20/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit

class PaymentHistoryViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
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
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentHistoryTableViewCell", for: indexPath) as? PaymentHistoryTableViewCell
        cell?.transactionIdLabel.text = transactionList[indexPath.row]["id"] as! String
        cell?.dateLabel.text = transactionList[indexPath.row]["date"] as! String
        cell?.amountLabel.text = transactionList[indexPath.row]["amount"] as! String
        cell?.amountLabel.textColor = indexPath.row % 2 == 0 ? ColorPalette.whiteColor : ColorPalette.redColor
        cell?.selectionStyle = .none
        return cell!
    }


}
