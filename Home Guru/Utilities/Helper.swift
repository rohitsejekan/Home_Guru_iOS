//
//  Helper.swift
//  Home Guru
//
//  Created by Priya Vernekar on 10/10/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

enum StateCityPickerType {
   case state, city
}

enum DoBProgramPickerType {
   case dob, program
}

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet : Bool {
        return self.sharedInstance.isReachable
    }
}

private let manager = NetworkReachabilityManager(host: "www.apple.com")
func isNetworkReachable() -> Bool {
    return manager?.isReachable ?? false
}

public func JSONStringify(withJSON value: AnyObject, pretyPrinted: Bool = false) -> Data?{
    let options = pretyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
    
    if JSONSerialization.isValidJSONObject(value) {
        do {
            let data = try JSONSerialization.data(withJSONObject: value, options: options)
            return data
        }
        catch { print("Couldn't serialize JSON.") }
    }
    return nil
}

public func customTextFieldPlaceholder(text: String, textField: UITextField) {
    let textAttriburedString = NSMutableAttributedString(string: text + "*", attributes: [.foregroundColor: ColorPalette.textColor])
    textField.attributedPlaceholder = textAttriburedString
}

public func customTextFieldWithoutAsterikPlaceholder(text: String, textField: UITextField) {
    textField.attributedPlaceholder = NSMutableAttributedString(string: text, attributes: [.foregroundColor: ColorPalette.textColor])
}

func convertTimeFrom24To12HourFormat(time: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss"
    let dateFormatter1 = DateFormatter()
    dateFormatter1.dateFormat = "hh:mm a"
    return dateFormatter1.string(from: dateFormatter.date(from: time)!)
}

func getDateString(format: String, date: Date) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

func getDateFromString(format: String, dateString: String) -> Date{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.date(from: dateString)!
}

