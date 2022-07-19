//
//  User.swift
//  TinderClone
//
//  Created by Macbook Air on 19.07.2022.
//

import Foundation
import UIKit

struct User: CreateProfileViewModel {
    let userName : String
    let job : String
    let age : Int
    let imageNames : [String]
    
    func createUserProfileViewModel() -> UserProfileViewModel { // model, view model ile bu fonksiyon araciligiyla haberlesir. UserProfileViewModel ile haberlesiyor.
        let attributedText = NSMutableAttributedString(string: userName,
                                                       attributes: [.font : UIFont.systemFont(ofSize: 30, weight: .heavy)])
        attributedText.append(NSAttributedString(string: " \(age)",
                                                 attributes: [.font : UIFont.systemFont(ofSize: 25, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n\(job)",
                                                 attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .light)]))

        
        return UserProfileViewModel(attributedString: attributedText, imageNames: imageNames, infoLocation: .left)
    }
}
