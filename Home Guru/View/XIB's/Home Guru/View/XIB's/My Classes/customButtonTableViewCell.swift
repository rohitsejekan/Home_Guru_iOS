//
//  customButtonTableViewCell.swift
//  Home Guru
//
//  Created by Priya Vernekar on 13/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit
protocol nextScreen: class {
    func gotoScreen()
}
class customButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var btn: UIButton!
    weak var goToDelegate: nextScreen!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btn.layer.cornerRadius = 5
    }
    @IBAction func nextBtn(_ sender: UIButton) {
        goToDelegate.gotoScreen()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
