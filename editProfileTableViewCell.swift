//
//  editProfileTableViewCell.swift
//  Home Guru
//
//  Created by Priya Vernekar on 19/04/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit

class editProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var editClass: UIButton!
    
    @IBOutlet weak var editYear: UITextField!
    @IBOutlet weak var editMonth: UITextField!
    @IBOutlet weak var editDate: UITextField!
    @IBOutlet weak var editName: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
