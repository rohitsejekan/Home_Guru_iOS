//
//  DatePickerView.swift
//  Home Guru
//
//  Created by Priya Vernekar on 16/12/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
protocol DatePickerProtocol {
    func dismiss()
    func getSelectedDate(date: String)
}

class DatePickerView: UIView {

    @IBOutlet weak var datePickerOuterView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    var delegate : DatePickerProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        datePicker.maximumDate = Date()
        datePickerOuterView.dropShadow(width: 1.0, height: 1.0)
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        delegate?.dismiss()
    }
    
    @IBAction func okBtnAction(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        delegate?.getSelectedDate(date: dateFormatter.string(from: datePicker.date))
        removeFromSuperview()
    }
    
    func showDatePickerView(onView: UIView) {
        self.frame = CGRect(x: 0, y: -50, width: onView.frame.size.width, height: onView.frame.size.height+50)
        onView.addSubview(self)
    }
    
    func hideTimerPickerView() {
        removeFromSuperview()
    }
    
}

