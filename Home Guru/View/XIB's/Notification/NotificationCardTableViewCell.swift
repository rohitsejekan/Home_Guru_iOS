//
//  NotificationCardTableViewCell.swift
//  Home Guru
//
//  Created by Priya Vernekar on 20/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit

class NotificationCardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var notificationTitleLabel: UILabel!
    @IBOutlet weak var notificationMsgLabel: UILabel!
    @IBOutlet weak var notificationDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
