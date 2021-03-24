//
//  customTextField.swift
//  Home Guru
//
//  Created by Priya Vernekar on 22/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import Foundation
import UIKit
class TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
