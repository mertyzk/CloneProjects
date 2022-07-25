//
//  MembershipViewModel.swift
//  TinderClone
//
//  Created by Macbook Air on 24.07.2022.
//

import Foundation
import Firebase

class MembershipViewModel {
    var signingIn = Bindable<Bool>()
    var isEmailPasswordFormatVerified = Bindable<Bool>()
    
    var emailAdress: String? {
        didSet {
            isEmailAndPassControl()
        }
    }
    
    var password: String? {
        didSet {
            isEmailAndPassControl()
        }
    }
    
    fileprivate func isEmailAndPassControl(){
        let verified = emailAdress?.isEmpty == false && password?.isEmpty == false // email adresi ya da parola gecersizse, verified false olacaktır.
        isEmailPasswordFormatVerified.value = verified
    }
    
    func signIn(completion: @escaping (Error?) -> ()){  // oturum acma isleminin sonunda ne calistirmak istiyorsak onu calistiracagiz. escaping sayesinde.
        guard let emailAdress = emailAdress, let password = password else {
            return
        }
        
        // signingIn.value = true olabilmesi icin oncelikle email adresi ve parolanin duzgun formatta alinmis olmasi gerekiyor.
        // eger boyleyse yani true ise artik oturum acma islemi basarili olabilir dedik ve true atadik.
        
        signingIn.value = true // oturum acma islemi asamasina gectik. artik oturum acma islemini saglama adimina gecebiliriz.
        Auth.auth().signIn(withEmail: emailAdress, password: password) { result, error in
            completion(error)
        }

    }
    
}
