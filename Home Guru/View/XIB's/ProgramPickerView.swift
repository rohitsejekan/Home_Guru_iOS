//
//  ProgramPickerView.swift
//  Koala-Parent
//
//  Created by Priya Vernekar on 28/09/20.
//  Copyright © 2020 Koala. All rights reserved.
//

import UIKit
protocol ProgramPickerProtocol {
    func dismissProgramPicker()
    func getSelectedProgram(programName: String)
}

class ProgramPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var programPickerOuterView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    var delegate : ProgramPickerProtocol?
    var programList : [[String:Any]] = []
    var pgList: [String] = []
    var pgStatus: Bool = true

    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.delegate = self
        pickerView.dataSource = self
        programPickerOuterView.dropShadow(width: 1.0, height: 1.0)
        getProgramList()
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
    
    func getProgramList() {
        AlamofireService.alamofireService.getRequestWithContentType(url: URLManager.sharedUrlManager.getProgramList, parameters: nil) { response in
                switch response.result {
                case .success(let value):
                    if let status =  response.response?.statusCode {
                        print("status is ..\(status)")
                        if status == 200 || status == 201 {
                            if let result = value as? [[String:Any]] {
                                print("result is ..\(result)")
                                self.programList = result
                                self.pickerView.reloadAllComponents()
                            }
                        }
                    }
                case .failure( _):
                     print("API call failed...")
                }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pgStatus == false{
            return pgList.count
        }else{
            return programList.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pgStatus == false{
            return pgList[row]
        }else{
            return self.programList[row]["program"] as? String ?? "ok empty now"

        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pgStatus == false{
            UIView.animate(withDuration: 1.0) {
                               self.delegate?.getSelectedProgram(programName: self.pgList[row])
                               self.removeFromSuperview()
                           }
       
        }else{
            UIView.animate(withDuration: 1.0) {
                         self.delegate?.getSelectedProgram(programName: self.programList[row]["program"] as? String ?? "ok empty now")
                         self.removeFromSuperview()
                     }
        }
  
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pgStatus == false{
              return NSAttributedString(string: pgList[row], attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        }else{
              return NSAttributedString(string: programList[row]["program"] as? String ?? "ok empty now", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        }
      
    }

}
