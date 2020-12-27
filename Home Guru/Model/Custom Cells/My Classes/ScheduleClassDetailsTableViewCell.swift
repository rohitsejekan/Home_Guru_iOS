//
//  ScheduleClassDetailsTableViewCell.swift
//  Home Guru
//
//  Created by Priya Vernekar on 16/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit

class ScheduleClassDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardOuterView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var classTypeImageView: UIImageView!
    @IBOutlet weak var classTypeLabel: UILabel!
    @IBOutlet weak var teacherNameLabel: UILabel!
    @IBOutlet weak var classImageView: UIImageView!
    @IBOutlet weak var firstStarImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    @IBOutlet weak var fourthImageView: UIImageView!
    @IBOutlet weak var fifthImageView: UIImageView!
    @IBOutlet weak var subjectLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardOuterView.dropShadow(width: 1.0, height: 1.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
