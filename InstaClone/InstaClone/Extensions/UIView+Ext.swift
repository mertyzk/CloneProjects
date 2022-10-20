//
//  UIView+Ext.swift
//  InstaClone
//
//  Created by Macbook Air on 20.10.2022.
//

import Foundation
import UIKit

struct AnchorConstraints {
    var top : NSLayoutConstraint?
    var bottom : NSLayoutConstraint?
    var leading : NSLayoutConstraint?
    var trailing : NSLayoutConstraint?
    var width : NSLayoutConstraint?
    var height : NSLayoutConstraint?
}

extension UIView {
    
    @discardableResult // Ignore Warning
    func anchor(top: NSLayoutYAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?,
                leading: NSLayoutXAxisAnchor?,
                trailing: NSLayoutXAxisAnchor?,
                padding: UIEdgeInsets = .zero,
                size: CGSize = .zero) -> AnchorConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchorConstraint = AnchorConstraints()
        
        if let top = top {
            anchorConstraint.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let bottom = bottom {
            anchorConstraint.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let leading = leading {
            anchorConstraint.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        if let trailing = trailing {
            anchorConstraint.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if size.width != 0 {
            anchorConstraint.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        
        if size.height != 0 {
            
            anchorConstraint.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [anchorConstraint.top, anchorConstraint.bottom, anchorConstraint.leading, anchorConstraint.trailing, anchorConstraint.height, anchorConstraint.width].forEach {
            $0?.isActive = true
        }
        
        return anchorConstraint
    }
}
