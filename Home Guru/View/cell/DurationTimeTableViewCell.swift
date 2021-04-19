//
//  DurationTimeTableViewCell.swift
//  Home Guru
//
//  Created by Priya Vernekar on 12/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit
protocol DurtionTimeDelegate {
    func selectDuration(index: Int)
    func getStartTime(index: Int)
//    func selectBoard(index: Int)
//    func selectClass(index: Int)
}


class DurationTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var selectDuration: UIButton!
    @IBOutlet weak var selectStartTime: UIButton!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var subjectName: UILabel!
    @IBOutlet weak var startTimeTextField: UITextField!
    var delegate : DurtionTimeDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func selectDuration(_ sender: UIButton) {
        delegate?.getStartTime(index: sender.tag)
        
    }
    
    @IBAction func selectTimeStart(_ sender: UIButton) {
        delegate?.selectDuration(index: sender.tag)
    }
}
