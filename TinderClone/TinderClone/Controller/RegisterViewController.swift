//
//  RegisterViewController.swift
//  TinderClone
//
//  Created by Macbook Air on 20.07.2022.
//

import UIKit

class RegisterViewController: UIViewController {
    
    let buttonSelectPhoto : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.heightAnchor.constraint(equalToConstant: 400).isActive = true
        return button
    }()
    
    let textFieldForEmail : PrivateTextField = {
        let textField = PrivateTextField(padding: 15)
        textField.backgroundColor = .white
        textField.placeholder = "Email Adress"
        textField.keyboardType = .emailAddress
        textField.addTarget(self, action: #selector(catchTheTextFieldChange), for: .editingChanged)
        return textField
    }()
    
    let textFieldForNameandSurname : PrivateTextField = {
        let textField = PrivateTextField(padding: 15)
        textField.backgroundColor = .white
        textField.placeholder = "Name - Surname"
        textField.addTarget(self, action: #selector(catchTheTextFieldChange), for: .editingChanged)
        return textField
    }()
    
    let textFieldForPassword : PrivateTextField = {
        let textField = PrivateTextField(padding: 15)
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
        button.isEnabled = false
        button.layer.cornerRadius = 25
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGradientLayer()
        editLayout()
        createNotificationObserver()
        tapGestureRecognizer()
        registerViewControllerObser()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self) // ekran kaybolduğunda remove.
    }
    
    fileprivate let gradientLayer = CAGradientLayer()
    
    fileprivate func createGradientLayer(){
        let topColour = #colorLiteral(red: 0.8174705505, green: 1, blue: 0.6763908267, alpha: 1)
        let bottomColour = #colorLiteral(red: 0, green: 0.3948368728, blue: 0, alpha: 1)
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
        
        view.addSubview(registerStackView)
        
        registerStackView.axis = .vertical
        buttonSelectPhoto.widthAnchor.constraint(equalToConstant: 240).isActive = true
        registerStackView.spacing = 10
        
        _ = registerStackView.anchor(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,
                                     padding: .init(top: 0, left: 45, bottom: 0, right: 45))
        registerStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
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
    
    @objc fileprivate func catchTheTap(tapGesture: UITapGestureRecognizer){
        
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity // klavye kaybolurken arkaplandaki siyahlığı kaldırdık.
        }, completion: nil)
        
        
    }
    
    @objc fileprivate func catchTheTextFieldChange(textField : UITextField){
        
        switch textField {
        case textFieldForEmail :
            registerVC.emailAdress = textField.text
        case textFieldForPassword :
            registerVC.password = textField.text
        case textFieldForNameandSurname :
            registerVC.nameSurname = textField.text
        default:
            break
        }
        
        /*let validData = textFieldForEmail.text?.isEmpty == false && textFieldForPassword.text?.isEmpty == false && textFieldForNameandSurname.text?.isEmpty == false
         
         */
        
    }
    
    var registerVC : RegisterViewModel = RegisterViewModel()
    
    fileprivate func registerViewControllerObser(){
        registerVC.savedDataIsValidObserver = { (valid) in
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
    }
    
    
}
