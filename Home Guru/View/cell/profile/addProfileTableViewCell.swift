//
//  addProfileTableViewCell.swift
//  Home Guru
//
//  Created by Priya Vernekar on 16/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit

class addProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var editName: UITextField!
    
    @IBOutlet weak var classEdit: UITextField!
    
    @IBOutlet weak var boardEdit: UITextField!
    
    @IBOutlet weak var yearEdit: UITextField!
    @IBOutlet weak var monthEdit: UITextField!
    @IBOutlet weak var dateEdit: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.editName.layer.cornerRadius = 5
         self.classEdit.layer.cornerRadius = 5
         self.boardEdit.layer.cornerRadius = 5
        self.yearEdit.layer.cornerRadius = 5
        self.monthEdit.layer.cornerRadius = 5
        self.dateEdit.layer.cornerRadius = 5

        // Configure the view for the selected state
    }

}
