//
//  UserProfileHeader.swift
//  InstaClone
//
//  Created by Macbook Air on 23.10.2022.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage

class UserProfileHeader: UICollectionReusableView {
    
    static let reuseID = "headerID"
    
    var currentUser: User? {
        didSet{
            print("####################################")
            guard let URL = URL(string: currentUser?.profileImageURL ?? "") else { return }
            profileImageView.sd_setImage(with: URL)
        }
    }
    
    lazy var profileImageView: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .yellow
        return img
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, bottom: nil, leading: self.leadingAnchor, trailing: nil, padding: .init(top: 15, left: 15, bottom: 0, right: 0), size: .init(width: 90, height: 90))
        profileImageView.layer.cornerRadius = 45
        profileImageView.clipsToBounds      = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
