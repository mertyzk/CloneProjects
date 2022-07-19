//
//  MainViewBottomStackView.swift
//  TinderClone
//
//  Created by Macbook Air on 18.07.2022.
//

import UIKit

class BottomStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 90).isActive = true

        let bottomSubView = [UIImage(named: "yenile"), UIImage(named: "kapat"), UIImage(named: "superLike"), UIImage(named: "like"), UIImage(named: "boost")].map { (image) -> UIView in
            let button = UIButton(type: .system)
            button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            return button
        }
        
        bottomSubView.forEach { (view) in
            addArrangedSubview(view)
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("Init(coder) not implemented")
    }

}
