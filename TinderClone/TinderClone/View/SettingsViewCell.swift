//
//  SettingsViewCell.swift
//  TinderClone
//
//  Created by Macbook Air on 22.07.2022.
//

import UIKit

class SettingsViewCell: UITableViewCell {
    
    class SettingsTextField : UITextField {
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 25, dy: 0) // placeholder'a sol-sag bosluk
        }
        
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 25, dy: 0)
        }
        
        override var intrinsicContentSize: CGSize {
            return .init(width: 0, height: 35)
        }
    }

    let textField : UITextField = {
       let textField = SettingsTextField()
        textField.placeholder = "Yaşınızı Giriniz"
        return textField
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //contentView.addSubview(textField) 
        addSubview(textField) //cell.contentView.isUserInteractionEnabled = false (SettingsVC - CellForRowAt Check)
        textField.fillSuperView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
