//
//  MyClassInfoTableViewCell.swift
//  Home Guru
//
//  Created by Priya Vernekar on 03/12/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit

class MyClassInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var actionBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
