//
//  Helper.swift
//  Shereal
//
//  Created by Bitjini on 30/12/20.
//  Copyright © 2020 Bitjini. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    func toData() -> Data? {
        return self.jpegData(compressionQuality: 0.5)
    }
}
//dates format

public extension Date {
    func convertToFormat(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: self)
    }
}
public extension String {
    /**
     Calculates the best height of the text for available width and font used.
     */
    public func heightForWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let rect = NSString(string: self).boundingRect(
            with: CGSize(width: width, height: CGFloat(MAXFLOAT)),
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )
        return ceil(rect.height)
    }
    
    public func toDate(fromFormat format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier: "GMT")
        return formatter.date(from: self)
    }
    
    func toURL() -> URL? {
        //guard let string = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        print(URL(string: self) ?? "Error: nil generated url.")
        return URL(string: self)
    }
}

public func JSONStringify(withJSON value: AnyObject, prettyPrinted: Bool = false) -> Data? {
    let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
    
    if JSONSerialization.isValidJSONObject(value) {
        do
        {
            let data = try JSONSerialization.data(withJSONObject: value,
                                                  options: options)
            return data
        }
        catch { print("Couldn't serialize JSON.") }
    }
    return nil
}
