//
//  ScheduleSubject_4TableViewCell.swift
//  Home Guru
//
//  Created by Priya Vernekar on 12/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit

class ScheduleSubject_4TableViewCell: UITableViewCell {


    @IBOutlet weak var toggleImage: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checked = false
        self.layoutMargins = UIEdgeInsets.zero
        self.separatorInset = UIEdgeInsets.zero
    }
    
    //Handles the cell selected state
    var checked: Bool! {
        didSet {
            if (self.checked == true) {
                self.toggleImage.image = UIImage(named: "checkBox")
                print("checked")
            }else{
                self.toggleImage.image = UIImage(named: "ch")
                print("unchecked")
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
