//
//  ConfirmScheduleSecondTableViewCell.swift
//  Home Guru
//
//  Created by Priya Vernekar on 15/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit

class ConfirmScheduleSecondTableViewCell: UITableViewCell {

    @IBOutlet weak var subjectContainer: UIView!
    @IBOutlet weak var subjectTime: UILabel!
    @IBOutlet weak var subjectName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
