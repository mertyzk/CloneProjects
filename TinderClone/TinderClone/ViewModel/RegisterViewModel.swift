//
//  RegisterViewModel.swift
//  TinderClone
//
//  Created by Macbook Air on 20.07.2022.
//

import Foundation
import UIKit

struct RegisterViewModel {
    
    var emailAdress : String? {
        didSet {
            controlOfValidData()
        }
    }
    var nameSurname : String? {
        didSet {
            controlOfValidData()
        }
    }
    var password : String? {
        didSet {
            controlOfValidData()
        }
    }
    
    fileprivate func controlOfValidData(){
        let valid = emailAdress?.isEmpty == false && nameSurname?.isEmpty == false && password?.isEmpty == false
        savedDataIsValidObserver?(valid)
    }
    
    var savedDataIsValidObserver : ((Bool) -> ())?
}
