//
//  UIColor+Ext.swift
//  InstaClone
//
//  Created by Macbook Air on 20.10.2022.
//

import Foundation
import UIKit

extension UIColor {
    
    static func convertToRgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
}
