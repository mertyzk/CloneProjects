//
//  UserProfileVC.swift
//  InstaClone
//
//  Created by Macbook Air on 21.10.2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import Foundation

class UserProfileVC: UICollectionViewController {
    
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "User"
        getUser()
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UserProfileHeader.reuseID)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UserProfileHeader.reuseID, for: indexPath) as! UserProfileHeader
        header.currentUser = currentUser
        return header
    }

    fileprivate func getUser(){
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("Users").document(currentUserID).getDocument { snapshot, error in
            if error != nil {
                print("Get user error: ", error ?? "Get user error.")
                return
            }
            guard let userData = snapshot?.data() else { return }
            //let userName = userData["UserName"] as! String
            self.currentUser = User(userData: userData)
            self.collectionView.reloadData()
            DispatchQueue.main.async {
                self.navigationItem.title = self.currentUser?.userName
            }
        }
        
    }

}

extension UserProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}
