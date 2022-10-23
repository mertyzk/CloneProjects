//
//  ViewController.swift
//  InstaClone
//
//  Created by Macbook Air on 20.10.2022.
//

import UIKit
import Firebase
import JGProgressHUD
import FirebaseFirestore

class ViewController: UIViewController {
    
    lazy var addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "addphotobuttonimage").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(choosePhoto), for: .touchUpInside)
        return button
    }()
    
    lazy var emailTextField: UITextField = {
        let textField               = UITextField()
        textField.placeholder       = "Email adresinizi giriniz."
        textField.backgroundColor   = UIColor(white: 0, alpha: 0.05)
        textField.borderStyle       = .roundedRect
        textField.font              = UIFont.systemFont(ofSize: 16)
        textField.addTarget(self, action: #selector(textFieldControl), for: .editingChanged)
        return textField
    }()
    
    lazy var userNameTextField: UITextField = {
        let textField               = UITextField()
        textField.placeholder       = "Kullanıcı adınızı giriniz."
        textField.backgroundColor   = UIColor(white: 0, alpha: 0.05)
        textField.borderStyle       = .roundedRect
        textField.font              = UIFont.systemFont(ofSize: 16)
        textField.addTarget(self, action: #selector(textFieldControl), for: .editingChanged)
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField               = UITextField()
        textField.placeholder       = "Şifreniz"
        textField.backgroundColor   = UIColor(white: 0, alpha: 0.05)
        textField.borderStyle       = .roundedRect
        textField.font              = UIFont.systemFont(ofSize: 16)
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(textFieldControl), for: .editingChanged)
        return textField
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kayıt Ol", for: .normal)
        button.tintColor            = .white
        button.layer.cornerRadius   = 7
        button.titleLabel?.font     = UIFont.systemFont(ofSize: 16)
        button.backgroundColor      = .lightGray
        button.addTarget(self, action: #selector(registerButtonClicked), for: .touchUpInside)
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
        
        addPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: nil, trailing: nil, padding: .init(top: 35, left: 0, bottom: 0, right: 0), size: .init(width: 250, height: 250))
        addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        stackView.anchor(top: addPhotoButton.bottomAnchor, bottom: nil, leading: addPhotoButton.leadingAnchor, trailing: addPhotoButton.trailingAnchor, padding: .init(top: 35, left: 0, bottom: 0, right: 0))
    }
    
    
    @objc fileprivate func registerButtonClicked(){
        guard let emailAdress = emailTextField.text, let userName = userNameTextField.text, let password = passwordTextField.text else { return }
        
        let hud               = JGProgressHUD(style: .light)
        hud.textLabel.text    = "Registering..."
        hud.show(in: self.view)
        
        Auth.auth().createUser(withEmail: emailAdress, password: password) { result, error in
            if error != nil {
                hud.textLabel.text = "\(error?.localizedDescription ?? "Register Error")"
                hud.dismiss(afterDelay: 1.5, animated: true)
                return
            }
            
            guard let registeredUserID = result?.user.uid else { return }
            
            let imageName = UUID().uuidString // randomly image string name
            let reference = Storage.storage().reference(withPath: "/ProfileImages/\(imageName)")
            let imageData = self.addPhotoButton.imageView?.image?.jpegData(compressionQuality: 0.8) ?? Data() // Is imageview nil? Send empty data
            
            reference.putData(imageData) { _, error in
                if error != nil {
                    print("Upload error: \(error?.localizedDescription ?? "Upload error")")
                    return
                }
                print("Upload successfully")
                
                reference.downloadURL { url, error in
                    if error != nil {
                        print("Upload error: \(error?.localizedDescription ?? "Download URL error")")
                    }
                    print("URL: \(url?.absoluteString ?? "No URL")")
                    
                    let willBeAddedData = ["UserName" : userName,
                                           "UserID" : registeredUserID,
                                           "ProfileImageURL" : url?.absoluteString ?? ""]
                    Firestore.firestore().collection("Users").document(registeredUserID).setData(willBeAddedData) { error in
                        if error != nil{
                            print("Firestore save error: \(error?.localizedDescription ?? "Firestore Save Error")")
                            return
                        }
                        print("Datas of user save successfully")

                    }
                    
                    hud.dismiss(animated: true)
                    self.resetAppearance()
                }
            }
        }
    }
    
    fileprivate func resetAppearance(){
        self.addPhotoButton.setImage(#imageLiteral(resourceName: "addphotobuttonimage").withRenderingMode(.alwaysOriginal), for: .normal)
        self.addPhotoButton.layer.borderColor   = UIColor.clear.cgColor
        self.addPhotoButton.layer.borderWidth   = 0
        self.emailTextField.text                = ""
        self.userNameTextField.text             = ""
        self.passwordTextField.text             = ""
    }
    
    
    @objc fileprivate func textFieldControl(){
        
        let isTextFieldsValidate = (emailTextField.text?.count ?? 0) > 0 &&
        (userNameTextField.text?.count ?? 0) > 0 &&
        (passwordTextField.text?.count ?? 0) > 0
        if isTextFieldsValidate {
            registerButton.isEnabled       = true
            registerButton.backgroundColor = .systemBlue
        } else {
            registerButton.isEnabled       = false
            registerButton.backgroundColor = .lightGray

        }
    }
    
    
    @objc fileprivate func choosePhoto(){
        let imgPickerController         = UIImagePickerController()
        imgPickerController.delegate    = self
        present(imgPickerController, animated: true)
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        self.addPhotoButton.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        addPhotoButton.layer.masksToBounds  = true
        addPhotoButton.layer.cornerRadius   = addPhotoButton.frame.width / 2
        addPhotoButton.layer.borderColor    = UIColor.darkGray.cgColor
        addPhotoButton.layer.borderWidth    = 3
        dismiss(animated: true)
    }

}

extension ViewController: UINavigationControllerDelegate {
    
}
