//
//  UserViewModel.swift
//  TinderClone
//
//  Created by Macbook Air on 19.07.2022.
//

import Foundation
import UIKit

class UserProfileViewModel {
    
    let attributedString : NSAttributedString
    let imageNames : [String]
    let infoLocation : NSTextAlignment
    
    init(attributedString : NSAttributedString, imageNames : [String], infoLocation : NSTextAlignment) {
        self.imageNames = imageNames
        self.attributedString = attributedString
        self.infoLocation = infoLocation
    }
    
    fileprivate var displayIndex = 0 {
        didSet {
            let imageURL = imageNames[displayIndex]
            displayIndexObserver?(displayIndex, imageURL)
        }
    }
    
    var displayIndexObserver : ( (Int, String?) -> () )?
    
    func getNextDisplay() {
        displayIndex = displayIndex + 1 >= imageNames.count ? 0 : displayIndex + 1
    }
    
    func getPreviousDisplay(){
        displayIndex = displayIndex - 1 < 0 ? imageNames.count - 1 : displayIndex - 1
    }
    
}

protocol CreateProfileViewModel {
    func createUserProfileViewModel() -> UserProfileViewModel
}
