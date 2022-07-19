//
//  Ads.swift
//  TinderClone
//
//  Created by Macbook Air on 19.07.2022.
//

import Foundation
import UIKit

struct Ads: CreateProfileViewModel {
    
    let title : String
    let brandName : String
    let imageName : String
    
    
    func createUserProfileViewModel() -> UserProfileViewModel {
        let attributedText = NSMutableAttributedString(string: title,
                                                       attributes: [.font : UIFont.systemFont(ofSize: 38, weight: .heavy)])
        attributedText.append(NSAttributedString(string: "\n\(brandName)",
                                                 attributes: [.font : UIFont.systemFont(ofSize: 28, weight: .bold)]))
        return UserProfileViewModel(attributedString: attributedText, imageNames: [imageName], infoLocation: .center)
    }

}
