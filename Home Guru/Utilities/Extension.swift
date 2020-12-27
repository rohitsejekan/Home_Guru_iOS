//
//  Extension.swift
//  Home Guru
//
//  Created by Priya Vernekar on 10/10/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func roundCorners(radius: CGFloat, corners: UIRectCorner) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func dropShadow(width: CGFloat, height: CGFloat) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: width, height: height)
    }
    
    func setGradientBackground() {
        let colorTop =  ColorPalette.gradientColor1.cgColor
        let colorBottom = ColorPalette.gradientColor2.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UIButton {
    func roundedButton(radius: CGFloat,backgroundColor: UIColor, textColor: UIColor) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.borderColor = ColorPalette.homeGuruOrangeColor.cgColor
        self.layer.borderWidth = 1
        self.setTitleColor(textColor, for: .normal)
        self.backgroundColor = backgroundColor
    }
}


extension UITextField {
    func asterikPlaceholder(text: String) {
        let attriburedString = NSMutableAttributedString(string: "text")
           let asterix = NSAttributedString(string: "*", attributes: [.foregroundColor: UIColor.red])
           attriburedString.append(asterix)
        self.attributedPlaceholder = attriburedString
    }
    
    func roundedCorners() {
        self.layer.cornerRadius = 4.0
        self.layer.masksToBounds = true
    }
}


extension Dictionary {
    subscript(i: Int) -> (key: Key, value: Value) {
        return self[index(startIndex, offsetBy: i)]
    }
}

extension Date {
//    var time: Time {
//        return Time(self)
//    }
    
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
}

