//
//  myRegisterViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 10/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit

class myRegisterViewController: UIViewController {

    
    @IBOutlet weak var backgroundImage: UIImageView!
    var userDetails : [String:Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImage.image = imageWithGradient(img: self.backgroundImage.image)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func getRegistered(_ sender: UIButton) {
        let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "RegisterParentViewController") as! RegisterParentViewController
                vc.userDetails = self.userDetails
                vc.hidesBottomBarWhenPushed = true
                self.present(vc, animated: true, completion: nil)
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
