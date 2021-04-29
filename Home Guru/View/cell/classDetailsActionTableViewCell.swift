//
//  classDetailsActionTableViewCell.swift
//  Home Guru
//
//  Created by Priya Vernekar on 08/04/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit

class classDetailsActionTableViewCell: UITableViewCell {

    @IBOutlet weak var reScheduleBtn: UIButton!
    @IBOutlet weak var cancelScheduleBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cancelScheduleBtn.layer.cornerRadius = 10
        cancelScheduleBtn.layer.borderWidth = 2
        cancelScheduleBtn.layer.borderColor = ColorPalette.homeGuruOrangeColor.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
