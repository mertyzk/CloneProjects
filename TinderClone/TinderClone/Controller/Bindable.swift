//
//  Bindable.swift
//  TinderClone
//
//  Created by Macbook Air on 21.07.2022.
//

import Foundation
import UIKit

class Bindable<K>{
    
    var value: K? {
        didSet {
            observer?(value)
        }
    }
    
    var observer : ((K?) -> ())?
    func setValue(observer: @escaping(K?) -> ()){
        self.observer = observer
    }
    
}
