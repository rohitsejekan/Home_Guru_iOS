//
//  SwitchProfileTableViewCell.swift
//  Home Guru
//
//  Created by Priya Vernekar on 05/05/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit

class SwitchProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var overLay: UIView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentDOB: UILabel!
    @IBOutlet weak var studentAddress: UILabel!
    
    @IBOutlet weak var parentEmail: UILabel!
    @IBOutlet weak var parentPhone: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
