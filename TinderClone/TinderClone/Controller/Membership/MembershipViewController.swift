//
//  MembershipViewController.swift
//  TinderClone
//
//  Created by Macbook Air on 24.07.2022.
//

import UIKit
import JGProgressHUD

class MembershipViewController: UIViewController {
    
    fileprivate let membershipViewModel = MembershipViewModel()
    fileprivate let membershipHUD = JGProgressHUD(style: .dark)
    
    
    let textFieldEmailAdress : PrivateTextField = {
        let textField = PrivateTextField(padding: 15, height: 45)
        textField.backgroundColor = .white
        textField.keyboardType = .emailAddress
        textField.placeholder = "E-mail adress"
        textField.addTarget(self, action: #selector(textFieldChangeControl), for: .editingChanged)
        return textField
    }()
    
    let textFieldPassword : PrivateTextField = {
        let textField = PrivateTextField(padding: 15, height: 45)
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true // for password
        textField.placeholder = "Password"
        textField.addTarget(self, action: #selector(textFieldChangeControl), for: .editingChanged)
        return textField
    }()
    
    let buttonSignIn : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.backgroundColor = #colorLiteral(red: 0, green: 0.5608807802, blue: 0.003525360953, alpha: 1)
        button.layer.cornerRadius = 25
        button.isEnabled = false
        button.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let buttonReturnToRegister : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(returnButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var verticalStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textFieldEmailAdress, textFieldPassword, buttonSignIn])
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @objc fileprivate func textFieldChangeControl(textField: UITextField){
        
    }
    
    @objc fileprivate func signInButtonPressed(){
        
    }
    
    @objc fileprivate func returnButtonPressed(){
        
    }
    
    
}
