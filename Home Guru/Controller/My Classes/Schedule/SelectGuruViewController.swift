//
//  SelectGuruViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 13/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit

class SelectGuruViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    

    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "SelectGuru", for: indexPath) as? SelectGuruTableViewCell
               
                  cell?.selectionStyle = .none
                  cell?.preservesSuperviewLayoutMargins = false
                        cell?.separatorInset = .zero
                        cell?.layoutMargins = .zero
          //        cell?.radioImageView.image = UIImage(named: indexPath.row == index ? "radioSelected" : "radioUnselected")
                
                  return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
               let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "MyGuruDetailsViewController") as! MyGuruDetailsViewController
                               //setNavigationBackTitle(title: "Schedule")
                               vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: false)

        
    }

}
