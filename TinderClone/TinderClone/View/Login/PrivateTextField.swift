//
//  PrivateTextField.swift
//  TinderClone
//
//  Created by Macbook Air on 20.07.2022.
//

import UIKit

class PrivateTextField : UITextField {
    
    let padding : CGFloat
    let height : CGFloat

        
    init(padding: CGFloat, height: CGFloat) {
        self.padding = padding
        self.height = height
        super.init(frame: .zero)
        layer.cornerRadius = 25
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize{
        // Yükseklik ataması
        return .init(width: 0, height: 50)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        // Text'in veri girilmemiş halinde boşlukları veya boyutu ayarlar
        return bounds.insetBy(dx: padding, dy: 0) // içeriye boşluk

    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        // Kullanıcı text field'a veri girerken boşluk bırakmasını sağlamaktadır.
        return bounds.insetBy(dx: padding, dy: height)
    }

    
}
