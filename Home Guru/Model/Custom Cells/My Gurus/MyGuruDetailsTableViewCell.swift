//
//  MyGuruDetailsTableViewCell.swift
//  Home Guru
//
//  Created by Priya Vernekar on 10/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit

class MyGuruDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var demoBtn: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var guruImage: UIImageView!
    @IBOutlet weak var guruNameLabel: UILabel!
    @IBOutlet weak var perClassAmountLabel: UILabel!
    @IBOutlet weak var firstStarImageView: UIImageView!
    @IBOutlet weak var secondStarImageView: UIImageView!
    @IBOutlet weak var thirdStarImageView: UIImageView!
    @IBOutlet weak var fourthStarImageView: UIImageView!
    @IBOutlet weak var fifthStarImageView: UIImageView!
    @IBOutlet weak var aboutDescriptionLabel: UILabel!
    @IBOutlet weak var qualificationLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var subjectsLabel: UILabel!
    
    @IBOutlet weak var subjectPlaceholder: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
