//
//  RegisterParentTableViewCell.swift
//  Home Guru
//
//  Created by Priya Vernekar on 10/10/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
protocol StudentSelectionProtocol {
    func getNoOfStudents(noOfStudents: Int)
}
class RegisterParentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var noOfStudentsOuterView: UIView!
    @IBOutlet weak var inputType1TextField: UITextField!
    @IBOutlet weak var selectLocationOuterView: UIView!
    @IBOutlet weak var inputType3TextField: UITextField!
    @IBOutlet weak var inputType2TextField: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var oneStudentRadioBtn: UIButton!
    @IBOutlet weak var selectedLocationOuterView: UIView!
    @IBOutlet weak var twoStudentRadioBtn: UIButton!
    @IBOutlet weak var threeStudentRadioBtn: UIButton!
    @IBOutlet weak var fourStudentRadioBtn: UIButton!
    var delegate : StudentSelectionProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func selectNoOfStudents(_ sender: UIButton) {
        setBtnValuesState(tag: sender.tag)
        delegate?.getNoOfStudents(noOfStudents: sender.tag)
    }
    
    func setBtnValuesState(tag: Int) {
        switch tag {
        case 1:
            oneStudentRadioBtn.isSelected = !(oneStudentRadioBtn.isSelected)
            setSelectedState(btn1State: (oneStudentRadioBtn.isSelected), btn2State: !(oneStudentRadioBtn.isSelected), btn3State: !(oneStudentRadioBtn.isSelected), btn4State: !(oneStudentRadioBtn.isSelected))
        case 2:
            twoStudentRadioBtn.isSelected = !(twoStudentRadioBtn.isSelected)
            setSelectedState(btn1State: !(twoStudentRadioBtn.isSelected), btn2State: (twoStudentRadioBtn.isSelected), btn3State: !(twoStudentRadioBtn.isSelected), btn4State: !(twoStudentRadioBtn.isSelected))
        case 3:
            threeStudentRadioBtn.isSelected = !(threeStudentRadioBtn.isSelected)
            setSelectedState(btn1State: !(threeStudentRadioBtn.isSelected), btn2State: !(threeStudentRadioBtn.isSelected), btn3State: (threeStudentRadioBtn.isSelected), btn4State: !(threeStudentRadioBtn.isSelected))
        default:
            fourStudentRadioBtn.isSelected = !(fourStudentRadioBtn.isSelected)
            setSelectedState(btn1State: !(fourStudentRadioBtn.isSelected), btn2State: !(fourStudentRadioBtn.isSelected), btn3State: !(fourStudentRadioBtn.isSelected), btn4State: (fourStudentRadioBtn.isSelected))
        }
    }
    
    func setSelectedState(btn1State: Bool,btn2State: Bool,btn3State: Bool, btn4State: Bool) {
        changeStateAndColor(btn: oneStudentRadioBtn, state: btn1State)
        changeStateAndColor(btn: twoStudentRadioBtn, state: btn2State)
        changeStateAndColor(btn: threeStudentRadioBtn, state: btn3State)
        changeStateAndColor(btn: fourStudentRadioBtn, state: btn4State)
    }
    
    func changeStateAndColor(btn: UIButton, state: Bool){
        btn.isSelected = state
        btn.roundedButton(radius: 23.5, backgroundColor: btn.isSelected ? ColorPalette.homeGuruOrangeColor : ColorPalette.homeGuruBlueColor, textColor: ColorPalette.whiteColor )
    }
    
    func setTextFieldPlaceholder(index: Int) {
        inputType1TextField.keyboardType = UIKeyboardType.default
        inputType1TextField.roundedCorners()
        switch index {
        case 1:
            customTextFieldWithoutAsterikPlaceholder(text: "  Parent Name", textField: inputType1TextField)
        case 2:
            inputType1TextField.keyboardType = UIKeyboardType.emailAddress
            customTextFieldWithoutAsterikPlaceholder(text: "  Email ID", textField: inputType1TextField)
        case 3:
            inputType1TextField.keyboardType = UIKeyboardType.emailAddress
            customTextFieldWithoutAsterikPlaceholder(text: "  Create Password", textField: inputType1TextField)
        case 4:
            inputType1TextField.keyboardType = UIKeyboardType.emailAddress
            customTextFieldWithoutAsterikPlaceholder(text: "  Confirm Password", textField: inputType1TextField)
        case 7:
            customTextFieldPlaceholder(text: "  Pincode", textField: inputType1TextField)
            inputType1TextField.keyboardType = UIKeyboardType.numberPad
        case 8:
            customTextFieldPlaceholder(text: "  House no., Building Name", textField: inputType1TextField)
        case 9:
            customTextFieldPlaceholder(text: "  Road Name, Area, Colony", textField: inputType1TextField)
        default:
            customTextFieldWithoutAsterikPlaceholder(text: "  Landmark(Optional)", textField: inputType1TextField)
        }
    }
    
    func setValue(index: Int, userDetails: [String:Any], address: [String:Any]) {
        switch index {
        case 1:
            if let name = userDetails["name"] as? String {
                inputType1TextField.text = name
            }
        case 2:
            if let email = userDetails["email"] as? String {
                inputType1TextField.text = email
            }
        case 3:
            if let email = userDetails["create_pass"] as? String {
                inputType1TextField.text = email
            }
        case 4:
            if let email = userDetails["confirm_pass"] as? String {
                inputType1TextField.text = email
            }
        case 7:
            if let pincode = address["pincode"] as? String {
                inputType1TextField.text = pincode
            }
        case 8:
            if let house_no = address["house_no"] as? String {
                inputType1TextField.text = house_no
            }
        case 9:
            if let area = address["area"] as? String {
                inputType1TextField.text = area
            }
        default:
            if let landmark = address["landmark"] as? String {
                inputType1TextField.text = landmark
            }
        }
    }
    
    func setCityStateAttributes() {
        inputType2TextField.roundedCorners()
        inputType3TextField.roundedCorners()
        customTextFieldPlaceholder(text: "  State", textField: inputType2TextField)
        customTextFieldPlaceholder(text: "  City", textField: inputType3TextField)
    }
    
    
}
