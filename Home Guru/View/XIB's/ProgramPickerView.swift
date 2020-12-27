//
//  ProgramPickerView.swift
//  Home Guru
//
//  Created by Priya Vernekar on 16/12/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
protocol ProgramPickerProtocol {
    func dismissProgramPicker()
    func getSelectedProgram(data: String)
}
class ProgramPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var programPickerOuterView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    var delegate : ProgramPickerProtocol?
    var programList : [String] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.delegate = self
        pickerView.dataSource = self
        programPickerOuterView.dropShadow(width: 1.0, height: 1.0)
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        delegate?.dismissProgramPicker()
    }
    
    func showProgramPickerView(onView: UIView) {
        self.frame = CGRect(x: 0, y: -50, width: onView.frame.size.width, height: onView.frame.size.height+50)
        onView.addSubview(self)
    }
    
    func hideProgramtPickerView() {
        removeFromSuperview()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return programList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.programList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UIView.animate(withDuration: 1.0) {
            self.delegate?.getSelectedProgram(data: self.programList[row])
            self.removeFromSuperview()
        }
    }
}
