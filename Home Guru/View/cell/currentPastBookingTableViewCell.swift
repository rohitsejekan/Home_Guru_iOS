//
//  currentPastBookingTableViewCell.swift
//  Home Guru
//
//  Created by Priya Vernekar on 26/04/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit

class currentPastBookingTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scheduleDate: UILabel!
    @IBOutlet weak var subjectName: UILabel!
    @IBOutlet weak var facultyImage: UIImageView!
    @IBOutlet weak var facultyName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
