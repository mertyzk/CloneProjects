//
//  User.swift
//  InstaClone
//
//  Created by Macbook Air on 23.10.2022.
//

import Foundation

struct User {
    let userID: String
    let userName: String
    let profileImageURL: String
    init(userData : [String : Any]) {
        self.userID = userData["UserID"] as? String ?? ""
        self.userName = userData["UserName"] as? String ?? ""
        self.profileImageURL = userData["ProfileImageURL"] as? String ?? ""
    }
}
