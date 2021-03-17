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
        self.layer.cornerRadius = 8.0
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

extension UIViewController{
    //gradient effect
      func imageWithGradient(img:UIImage!) -> UIImage {



                      UIGraphicsBeginImageContext(img.size)

                      let context = UIGraphicsGetCurrentContext()



                      img.draw(at: CGPoint(x: 0, y: 0))



                      let colorSpace = CGColorSpaceCreateDeviceRGB()

                let locations:[CGFloat] = [0.1, 1.0]



                let bottom = UIColor(red: 0, green: 0.1, blue: 0.2, alpha: 1).cgColor

        let top = UIColor(red: 0, green: 0.1, blue: 0.2, alpha: 0.3).cgColor



                      let colors = [top, bottom] as CFArray



                      let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)



                      let startPoint = CGPoint(x: img.size.width/2, y: 0)

                      let endPoint = CGPoint(x: img.size.width/2, y: img.size.height)
                      context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))



                      let image = UIGraphicsGetImageFromCurrentImageContext()



                      UIGraphicsEndImageContext()



                      return image!

                  }
      
}

extension UIImage {

    class func convertGradientToImage(colors: [UIColor], frame: CGRect) -> UIImage {

        // start with a CAGradientLayer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame

        // add colors as CGCologRef to a new array and calculate the distances
        var colorsRef = [CGColor]()
        var locations = [NSNumber]()

        for i in 0 ... colors.count-1 {
            colorsRef.append(colors[i].cgColor as CGColor)
            locations.append(NSNumber(value: Float(i)/Float(colors.count-1)))
        }

        gradientLayer.colors = colorsRef
        gradientLayer.locations = locations

        // now build a UIImage from the gradient
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // return the gradient image
        return gradientImage
    }
}

extension UILabel {
    func setMargins(margin: CGFloat = 10) {
        if let textString = self.text {
            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = margin
            paragraphStyle.headIndent = margin
            paragraphStyle.tailIndent = -margin
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}
// right to left animation present and dismiss vc

extension UIViewController {

    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)

        present(viewControllerToPresent, animated: false)
    }

    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)

        dismiss(animated: false)
    }
}
