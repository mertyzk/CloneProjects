//
//  MainViewBottomStackView.swift
//  TinderClone
//
//  Created by Macbook Air on 18.07.2022.
//

import UIKit

class BottomStackView: UIStackView {
    
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    let refreshButton = createButton(image: UIImage(named: "yenile")!)
    let closeButton = createButton(image: UIImage(named: "kapat")!)
    let superLikeButton = createButton(image: UIImage(named: "superLike")!)
    let likeButton = createButton(image: UIImage(named: "like")!)
    let boostButton = createButton(image: UIImage(named: "boost")!)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 90).isActive = true

        /*let bottomSubView = [UIImage(named: "yenile"), UIImage(named: "kapat"), UIImage(named: "superLike"), UIImage(named: "like"), UIImage(named: "boost")].map { (image) -> UIView in
            let button = UIButton(type: .system)
            button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            return button
        }
        
        bottomSubView.forEach { (view) in
            addArrangedSubview(view)
        }*/ //-->>> yerine
        
        [refreshButton,closeButton,superLikeButton,likeButton,boostButton].forEach { button in
            self.addArrangedSubview(button)
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("Init(coder) not implemented")
    }
}
