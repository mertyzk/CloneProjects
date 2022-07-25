//
//  RegisterViewController.swift
//  TinderClone
//
//  Created by Macbook Air on 20.07.2022.
//

import UIKit
import Firebase
import JGProgressHUD

class RegisterViewController: UIViewController {
    
    let buttonSelectPhoto : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 400).isActive = true
        button.addTarget(self, action: #selector(buttonSelectPhotoPressed), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        return button
    }()
    
    let textFieldForEmail : PrivateTextField = {
        let textField = PrivateTextField(padding: 15, height: 45)
        textField.backgroundColor = .white
        textField.placeholder = "Email Adress"
        textField.keyboardType = .emailAddress
        textField.addTarget(self, action: #selector(catchTheTextFieldChange), for: .editingChanged)
        return textField
    }()
    
    let textFieldForNameandSurname : PrivateTextField = {
        let textField = PrivateTextField(padding: 15, height: 45)
        textField.backgroundColor = .white
        textField.placeholder = "Name - Surname"
        textField.addTarget(self, action: #selector(catchTheTextFieldChange), for: .editingChanged)
        return textField
    }()
    
    let textFieldForPassword : PrivateTextField = {
        let textField = PrivateTextField(padding: 15, height: 45)
        textField.backgroundColor = .white
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(catchTheTextFieldChange), for: .editingChanged)
        return textField
    }()
    
    let registerButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        button.setTitleColor(.white, for: .disabled)
        button.layer.cornerRadius = 25
        button.isEnabled = false
        button.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.backgroundColor = #colorLiteral(red: 0, green: 0.5608807802, blue: 0.003525360953, alpha: 1)
        button.setTitleColor(.white, for: .disabled)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGradientLayer()
        editLayout()
        createNotificationObserver()
        tapGestureRecognizer()
        registerViewControllerObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self) // ekran kaybolduğunda remove.
    }
    
    fileprivate let gradientLayer = CAGradientLayer()
    
    fileprivate func createGradientLayer(){
        let topColour = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        let bottomColour = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        gradientLayer.colors = [topColour.cgColor, bottomColour.cgColor]
        gradientLayer.locations =  [0,1]
        view.layer.addSublayer(gradientLayer)
        // gradientLayer.frame = view.bounds - viewWillLayoutSubviews'a gönderdik ki layout (ekran döndüğünde) her değiştiğinde çalışsın.
    }
    
    override func viewWillLayoutSubviews() {
        // layout her değiştiğinde burası çalışır.
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    lazy var verticalStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            textFieldForEmail,
            textFieldForNameandSurname,
            textFieldForPassword,
            registerButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var registerStackView = UIStackView(arrangedSubviews: [buttonSelectPhoto, verticalStackView ])
    
    //MARK: - Which mode portrait or landscape work?
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact{ // landscape mod
            registerStackView.axis = .horizontal
        } else {
            registerStackView.axis = .vertical
        }
    }
    
    fileprivate func editLayout(){
        
        navigationController?.isNavigationBarHidden = true // navigation bar gizlendi
        
        view.addSubview(registerStackView)
        
        registerStackView.axis = .vertical
        buttonSelectPhoto.widthAnchor.constraint(equalToConstant: 240).isActive = true
        registerStackView.spacing = 10
        
        _ = registerStackView.anchor(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,
                                     padding: .init(top: 0, left: 45, bottom: 0, right: 45))
        registerStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(loginButton)
        _ = loginButton.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 45, bottom: 15, right: 45))
    }
    
    //MARK: - This function catch of the keyboard moves.
    fileprivate func createNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(catchTheKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil) // klavye ortaya cikinca yakalar.
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardIsHidden), name: UIResponder.keyboardWillHideNotification, object: nil) // klavye kaybolunca yakalar.
    }
    
    @objc fileprivate func catchTheKeyboard(notification: Notification){
        
        guard let keyboardFinishedValues = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardFinishedFrame = keyboardFinishedValues.cgRectValue
        
        let bottomSpace = view.frame.height - (registerStackView.frame.origin.y + registerStackView.frame.height) // alt bosluk miktari
        
        let tolerance = keyboardFinishedFrame.height - bottomSpace
        
        self.view.transform = CGAffineTransform(translationX: 0, y: -tolerance-12)
    }
    
    @objc fileprivate func keyboardIsHidden(notification: Notification){
        
        // catchTheTap fonksiyonundaki animasyonla aynı görevi yapar. Her ihtimale karşın garantiye alınmıştır.
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity // klavye kaybolurken arkaplandaki siyahlığı kaldırdık.
        }, completion: nil)
    }
    
    
    //MARK: - This function close the keyboard.
    fileprivate func tapGestureRecognizer(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(catchTheTap)))
    }
    
    @objc fileprivate func catchTheTap(){
        
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity // klavye kaybolurken arkaplandaki siyahlığı kaldırdık.
        }, completion: nil)
        
        
    }
    
    @objc fileprivate func catchTheTextFieldChange(textField : UITextField){
        
        switch textField {
        case textFieldForEmail :
            registerViewModel.emailAdress = textField.text
        case textFieldForPassword :
            registerViewModel.password = textField.text
        case textFieldForNameandSurname :
            registerViewModel.nameSurname = textField.text
        default:
            break
        }
        
        /*let validData = textFieldForEmail.text?.isEmpty == false && textFieldForPassword.text?.isEmpty == false && textFieldForNameandSurname.text?.isEmpty == false
         
         */
        
    }
    
    var registerViewModel : RegisterViewModel = RegisterViewModel()
    
    fileprivate func registerViewControllerObserver(){
        
        registerViewModel.bindableValidOfRegisterDatas.setValue { valid in
            guard let valid = valid else {
                return
            }
            
            self.registerButton.isEnabled = valid
            if valid {
                self.registerButton.backgroundColor = #colorLiteral(red: 0.3215686275, green: 0.1098039216, blue: 0.5058823529, alpha: 1)
                self.registerButton.setTitleColor(.white, for: .normal)
                self.registerButton.isEnabled = true
            } else {
                self.registerButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                self.registerButton.setTitleColor(.white, for: .disabled)
                self.registerButton.isEnabled = false
            }
        }
        
        registerViewModel.bindableImage.setValue { imgProfile in
            self.buttonSelectPhoto.setImage(imgProfile?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        registerViewModel.bindableRegistering.setValue { registering in
            if registering == true {
                self.registerHud.textLabel.text = "Registering..."
                self.registerHud.dismiss(afterDelay: 1, animated: true)
                self.registerHud.show(in: self.view)
            } else {
                self.registerHud.dismiss()
            }
        }
    }
    
    let registerHud = JGProgressHUD(style: .dark)
    @objc fileprivate func registerButtonPressed(){
        catchTheTap()
        registerViewModel.userRegister { error in
            if let error = error {
                self.errorInfoJGHud(error: error)
                return
            }
            print("Kayıt başarılı")
        }
    }
    
    fileprivate func errorInfoJGHud(error: Error){
        let errorHud = JGProgressHUD(style: .dark)
        errorHud.textLabel.text = "Register failed"
        errorHud.detailTextLabel.text = error.localizedDescription
        errorHud.show(in: self.view)
        errorHud.dismiss(afterDelay: 1.5, animated: true)
    }
    
    @objc fileprivate func buttonSelectPhotoPressed(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    @objc fileprivate func loginButtonPressed(){
        // login ekrani
        let signInController = UIViewController()
        signInController.view.backgroundColor = .blue
        navigationController?.pushViewController(signInController, animated: true)
        print("click click click click click click")
    }

}

extension RegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Press Cancel Button (Select photo step)
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        registerViewModel.bindableImage.value = selectedImage
        dismiss(animated: true)
    }
    
}
