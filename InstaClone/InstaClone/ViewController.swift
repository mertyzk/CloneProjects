//
//  ViewController.swift
//  InstaClone
//
//  Created by Macbook Air on 20.10.2022.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "addphotobuttonimage").withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email adresinizi giriniz."
        textField.backgroundColor = UIColor(white: 0, alpha: 0.05)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    lazy var userNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Kullanıcı adınızı giriniz."
        textField.backgroundColor = UIColor(white: 0, alpha: 0.05)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Şifreniz"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.05)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kayıt Ol", for: .normal)
        button.backgroundColor = .lightGray
        button.tintColor = .white
        button.layer.cornerRadius = 7
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.isEnabled = false
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, userNameTextField, passwordTextField, registerButton])
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        
    }
    
    func layoutUI(){
        view.addSubview(addPhotoButton)
        view.addSubview(stackView)
        
        addPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: nil, trailing: nil, padding: .init(top: 35, left: 0, bottom: 0, right: 0))
        addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        stackView.anchor(top: addPhotoButton.bottomAnchor, bottom: nil, leading: addPhotoButton.leadingAnchor, trailing: addPhotoButton.trailingAnchor, padding: .init(top: 35, left: 0, bottom: 0, right: 0))
    }
}

