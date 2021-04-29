//
//  SelectGuruTableViewCell.swift
//  Home Guru
//
//  Created by Priya Vernekar on 13/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit

class SelectGuruTableViewCell: UITableViewCell {
    @IBOutlet weak var GuruFarelabel: PaddedLabel!
    
    @IBOutlet weak var languageKnown: UILabel!
    @IBOutlet weak var guruFare: PaddedLabel!
    @IBOutlet weak var guruName: UILabel!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var facultyAvatar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.GuruFarelabel.layer.cornerRadius = 8
        self.GuruFarelabel.layer.borderColor = ColorPalette.homeGuruWhiteBorderColor.cgColor
        self.GuruFarelabel.layer.borderWidth = 1
        self.holderView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
