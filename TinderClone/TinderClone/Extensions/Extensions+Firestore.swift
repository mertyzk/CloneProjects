//
//  Extensions+Firestore.swift
//  TinderClone
//
//  Created by Macbook Air on 24.07.2022.
//

import Foundation
import Firebase
import UIKit

extension Firestore {
    func getByCurrentUser(completion: @escaping (User?, Error?) -> ()){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("Users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let informations = snapshot?.data() else {
                let error = NSError(domain: "TinderClone", code: 333, userInfo: [NSLocalizedDescriptionKey : "User Not Found"])
                completion(nil, error)
                return
            }
            
            let user = User(infos: informations)
            completion(user, nil)
        }
        
    }
}
