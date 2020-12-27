//
//  ScheduledClassCardTableViewCell.swift
//  Home Guru
//
//  Created by Priya Vernekar on 03/12/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit

class ScheduledClassCardTableViewCell: UITableViewCell {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var moduleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var demoLabel: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var thirdStarImageView: UIImageView!
    @IBOutlet weak var noOfDaysLeft: UILabel!
    @IBOutlet weak var fifthStarImageView: UIImageView!
    @IBOutlet weak var fourthStarImageView: UIImageView!
    @IBOutlet weak var secondStarImageView: UIImageView!
    @IBOutlet weak var firstStarImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dotImageView2: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dotImageView1: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var classImageView: UIImageView!
    
        override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        self.outerView.roundCorners(radius: 4.0, corners: [.topLeft,.topRight,.bottomLeft,.bottomRight])
        self.outerView.dropShadow(width: 1.0, height: 1.0)
        self.demoLabel.roundCorners(radius: 4.0, corners: [.topRight,.topLeft])
    }
    
    func setCardValues(data: [String:Any]) {
        if let classType = data["classType"] as? String {
            switch classType {
            case "old class":
                setAttributes(outerViewColor: ColorPalette.homeGuruDarkGreyColor, dateLabelColor: ColorPalette.homeGuruOrangeColor, nameLabelColor: ColorPalette.homeGuruLightGreyColor, moduleLabelColor: ColorPalette.homeGuruLightGreyColor, classLabelColor: ColorPalette.homeGuruLightGreyColor, noOfDaysLeftStatus: true, ratingsStatus: false, demoStatus: true)
            case "today":
                setAttributes(outerViewColor: ColorPalette.homeGuruOrangeColor, dateLabelColor: ColorPalette.homeGuruBlackColor, nameLabelColor: UIColor.white, moduleLabelColor: UIColor.white, classLabelColor: ColorPalette.homeGuruOrangeColor, noOfDaysLeftStatus: false, ratingsStatus: true, demoStatus: true)
            case "demo today":
                setAttributes(outerViewColor: ColorPalette.homeGuruOrangeColor, dateLabelColor: ColorPalette.homeGuruBlackColor, nameLabelColor: UIColor.white, moduleLabelColor: UIColor.white, classLabelColor: ColorPalette.homeGuruOrangeColor, noOfDaysLeftStatus: false, ratingsStatus: true, demoStatus: false)
            case "future":
                setAttributes(outerViewColor: ColorPalette.homeGuruDarkGreyColor, dateLabelColor: ColorPalette.homeGuruOrangeColor, nameLabelColor: UIColor.white, moduleLabelColor: UIColor.white, classLabelColor: ColorPalette.homeGuruLightGreyColor,  noOfDaysLeftStatus: false, ratingsStatus: true, demoStatus: true)
            default:
                setAttributes(outerViewColor: ColorPalette.homeGuruDarkGreyColor, dateLabelColor: ColorPalette.homeGuruOrangeColor, nameLabelColor: UIColor.white, moduleLabelColor: UIColor.white, classLabelColor: ColorPalette.homeGuruLightGreyColor,  noOfDaysLeftStatus: false, ratingsStatus: true, demoStatus: false)

            }
        }
    }
    
    func setAttributes(outerViewColor: UIColor,dateLabelColor: UIColor,nameLabelColor: UIColor,moduleLabelColor: UIColor,classLabelColor: UIColor,noOfDaysLeftStatus: Bool,ratingsStatus: Bool,demoStatus: Bool) {
        self.outerView.backgroundColor = outerViewColor
        self.dateLabel.textColor = dateLabelColor
        self.dayLabel.textColor = dateLabelColor
        self.timeLabel.textColor = dateLabelColor
        self.nameLabel.textColor = nameLabelColor
        self.moduleLabel.textColor = moduleLabelColor
        self.classImageView.backgroundColor = classLabelColor
        self.noOfDaysLeft.isHidden = noOfDaysLeftStatus
        self.ratingStackView.isHidden = ratingsStatus
        self.demoLabel.isHidden = demoStatus
    }
    
    
    
}
