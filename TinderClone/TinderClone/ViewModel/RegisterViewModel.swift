//
//  RegisterViewModel.swift
//  TinderClone
//
//  Created by Macbook Air on 20.07.2022.
//

import Foundation
import UIKit
import Firebase

struct RegisterViewModel {
    
    var bindableImage : Bindable = Bindable<UIImage>()
    var bindableValidOfRegisterDatas : Bindable = Bindable<Bool>()
    var bindableRegistering : Bindable = Bindable<Bool>()
    
    var emailAdress: String? {
        didSet {
            controlOfValidData()
        }
    }
    var nameSurname: String? {
        didSet {
            controlOfValidData()
        }
    }
    var password: String? {
        didSet {
            controlOfValidData()
        }
    }
    
    fileprivate func controlOfValidData(){
        let valid = emailAdress?.isEmpty == false && nameSurname?.isEmpty == false && password?.isEmpty == false
        bindableValidOfRegisterDatas.value = valid
    }
    
    func userRegister(completion: @escaping (Error?) -> ()){
        
        guard let emailAdress = emailAdress, let password = password else {
            return
        }
        
        bindableRegistering.value = true
        
        Auth.auth().createUser(withEmail: emailAdress, password: password) { result, error in
            if let error = error {
                completion(error)
                return
            }
            imageSaveToFirebase(completion: completion)
        }
    }
    
    fileprivate func imageSaveToFirebase(completion: @escaping (Error?) -> ()){
        let imageName = UUID().uuidString
        let referance = Storage.storage().reference(withPath: "/images/\(imageName)")
        let imageData = bindableImage.value?.jpegData(compressionQuality: 0.8) ?? Data()
        referance.putData(imageData, metadata: nil) { _, error in
            if error != nil {
                completion(error)
                return
            }
            referance.downloadURL { url, error in
                if let error = error {
                    completion(error)
                    return
                }
                // Register Success
                bindableRegistering.value = false
                print("Image URL: \(url?.absoluteString ?? "")")
                
                let imageURL = url?.absoluteString ?? ""
                self.userInfoSaveToFirebase(imageURL: imageURL, completion: completion)
            }
        }
    }
    
    fileprivate func userInfoSaveToFirebase(imageURL: String, completion: @escaping (Error?) -> ()){
        let userID = Auth.auth().currentUser?.uid ?? ""
        let dataToBeAdded = ["NameSurname" : nameSurname ?? "", "ImageURL" : imageURL, "UserID" : userID]
        Firestore.firestore().collection("Users").document(userID).setData(dataToBeAdded) { error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    
}
