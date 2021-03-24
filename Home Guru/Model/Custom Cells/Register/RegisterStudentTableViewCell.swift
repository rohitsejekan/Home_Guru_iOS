//
//  RegisterStudentTableViewCell.swift
//  Home Guru
//
//  Created by Priya Vernekar on 10/10/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit

protocol RegisterStudentDelegate {
    func selectDOB(index: Int)
    func getNameTextFieldValue(tag: Int, value: String)
    func selectBoard(index: Int)
    func selectClass(index: Int)
}

class RegisterStudentTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var studentLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var selectClassBtn: UIButton!
    @IBOutlet weak var selectBoardBtn: UIButton!
    @IBOutlet weak var selectDOBBtn: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var classTextField: UITextField!
    @IBOutlet weak var boardTextField: UITextField!


    var delegate : RegisterStudentDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func selectDOB(_ sender: UIButton) {
        delegate?.selectDOB(index: sender.tag)
    }
    
    @IBAction func selectBoard(_ sender: UIButton) {
        delegate?.selectBoard(index: sender.tag)
    }
    @IBAction func selectClass(_ sender: UIButton) {
        delegate?.selectClass(index: sender.tag)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != nil {
            delegate?.getNameTextFieldValue(tag: textField.tag, value: textField.text ?? "")
        }
    }
    
}
