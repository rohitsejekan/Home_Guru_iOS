//
//  editProfileTableViewCell.swift
//  Home Guru
//
//  Created by Priya Vernekar on 19/04/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit
protocol showDatePicker : class{
    func datePicker()
}
class editProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var editClass: UIButton!
    var datePickerDelegate: showDatePicker?
    @IBOutlet weak var dobBtn: UIButton!
    @IBOutlet weak var editName: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func showPicker(_ sender: UIButton) {
        datePickerDelegate?.datePicker()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
