//
//  MainViewHeaderStack.swift
//  TinderClone
//
//  Created by Macbook Air on 18.07.2022.
//

import UIKit

class HeaderStackView: UIStackView {

    let imgFlame = UIImageView(image: UIImage(named: "alev")?.withRenderingMode(.alwaysOriginal))
    let messageButton = UIButton(type: .system)
    let profileButton = UIButton(type: .system)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .equalCentering
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        isLayoutMarginsRelativeArrangement = true // stack view kenarlara bosluk vermek icin true ister.
        layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
        
        imgFlame.contentMode = .scaleAspectFit
        
        
        
        messageButton.setImage(UIImage(named: "mesaj")?.withRenderingMode(.alwaysOriginal), for: .normal)
        profileButton.setImage(UIImage(named: "profil")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        [profileButton, UIView(), imgFlame, UIView(), messageButton].forEach { view in
            addArrangedSubview(view)
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("Init(coder) not implemented")
    }
    
}
