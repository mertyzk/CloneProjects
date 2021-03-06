//
//  User.swift
//  TinderClone
//
//  Created by Macbook Air on 19.07.2022.
//

import Foundation
import UIKit

struct User: CreateProfileViewModel {
    var userName : String?
    var job : String?
    var age : Int?
    //let imageNames : [String]
    var imageURL1 : String?
    var imageURL2 : String?
    var imageURL3 : String?
    var userID : String
    var searchMinAge : Int?
    var searchMaxAge : Int?
    
    init(infos: [String : Any]) {
        self.userName = infos["NameSurname"] as? String ?? ""
        self.age = infos["Age"] as? Int
        self.job = infos["Job"] as? String
        
        self.imageURL1 = infos["ImageURL"] as? String
        self.imageURL2 = infos["ImageURL2"] as? String
        self.imageURL3 = infos["ImageURL3"] as? String
        self.userID = infos["UserID"] as? String ?? ""
        self.searchMinAge = infos["MinimumAge"] as? Int
        self.searchMaxAge = infos["MaximumAge"] as? Int
    }
    
    
    func createUserProfileViewModel() -> UserProfileViewModel { // model, view model ile bu fonksiyon araciligiyla haberlesir. UserProfileViewModel ile haberlesiyor.
        let attributedText = NSMutableAttributedString(string: userName ?? "",
                                                       attributes: [.font : UIFont.systemFont(ofSize: 30, weight: .heavy)])
        
        // Asagida append edilirken age ve job optional oldugu icin ekrana nil basar. nil basmamasi icin veri yoksa kendimiz bir deger atadik.
        let ageString = age != nil ? "\(age!)" : "**"
        let jobString = job != nil ? "\(job!)" : "No information"
        
        attributedText.append(NSAttributedString(string: " \(ageString)",
                                                 attributes: [.font : UIFont.systemFont(ofSize: 25, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n\(jobString)",
                                                 attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .light)]))
        
        var imagesURLs = [String]() // fotograf olmasa dahi eklemesini engellemek icin kullandik.
        if let url = imageURL1, !url.isEmpty {
            imagesURLs.append(url)
        }
        if let url = imageURL2, !url.isEmpty {
            imagesURLs.append(url)
        }
        if let url = imageURL3, !url.isEmpty {
            imagesURLs.append(url)
        }
        
        return UserProfileViewModel(attributedString: attributedText, imageNames: imagesURLs, infoLocation: .left)
    }
}
