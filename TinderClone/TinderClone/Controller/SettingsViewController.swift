//
//  SettingsController.swift
//  TinderClone
//
//  Created by Macbook Air on 22.07.2022.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

class SettingsViewController: UITableViewController {
    
    // button.addTarget action'u selector tipinden oldugu icin selector tipinden parametre aldi.
    fileprivate func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.setTitle("Select Photo", for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    lazy var selectionArea1 = createButton(selector: #selector(selectImageButtonPressed))
    lazy var selectionArea2 = createButton(selector: #selector(selectImageButtonPressed))
    lazy var selectionArea3 = createButton(selector: #selector(selectImageButtonPressed))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNavigation()
        tableView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.6862745098, blue: 0.1333333333, alpha: 1)
        tableView.keyboardDismissMode = .interactive
        getByUserInfo()

    }
    
    
    lazy var photoArea : UIView = {
        let photoArea = UIView()
        photoArea.addSubview(selectionArea1)
        _ = selectionArea1.anchor(top: photoArea.safeAreaLayoutGuide.topAnchor,
                                  bottom: photoArea.safeAreaLayoutGuide.bottomAnchor,
                                  leading: photoArea.safeAreaLayoutGuide.leadingAnchor,
                                  trailing: nil,
                                  padding: .init(top: 15, left: 15, bottom: 15, right: 0))
        selectionArea1.widthAnchor.constraint(equalTo: photoArea.widthAnchor, multiplier: 0.35).isActive = true
        

        let stackView = UIStackView(arrangedSubviews: [selectionArea2, selectionArea3])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        photoArea.addSubview(stackView)
        
        
        _ = stackView.anchor(top: photoArea.safeAreaLayoutGuide.topAnchor,
                             bottom: photoArea.safeAreaLayoutGuide.bottomAnchor,
                             leading: selectionArea1.trailingAnchor,
                             trailing: photoArea.safeAreaLayoutGuide.trailingAnchor,
                             padding: .init(top: 15, left: 15, bottom: 15, right: 15))
        
        
        return photoArea
    }()
    
    fileprivate func createNavigation() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(cancelButtonPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutButtonPressed))
    }
    
    @objc fileprivate func cancelButtonPressed(){
        dismiss(animated: true)
    }
    
    @objc fileprivate func logoutButtonPressed(){
        print("Oturum kapatılıyor.")
    }
    
    @objc fileprivate func selectImageButtonPressed(button: UIButton) {
    
        let imagePicker = CustomImagePickerController()
        imagePicker.buttonSelectImage = button
        imagePicker.delegate = self
        present(imagePicker,animated: true)
    }
    
    var currenUser : User?
    
    fileprivate func getByUserInfo(){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        Firestore.firestore().collection("Users").document(uid).getDocument { snapshot, fault in
            if let fault = fault {
                print("kullanıcı bilgileri getirilirken hata: \(fault)")
                return
            }
            
            guard let datas = snapshot?.data() else { return }
            self.currenUser = User(infos: datas)
            self.loadProfilePictures()
            self.tableView.reloadData()
        }
    }
    
    fileprivate func loadProfilePictures(){
        guard let imageURL = currenUser?.imageURL1, let url = URL(string: imageURL) else {
            return
        }
        
        SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { image, _, _, _, _, _ in
            self.selectionArea1.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    
    
}

extension SettingsViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return photoArea
        }
        let labelTitle = LabelTitle()
        switch section {
        case 1:
            labelTitle.text = "Name Surname"
        case 2:
            labelTitle.text = "Age"
        case 3:
            labelTitle.text = "Job"
        case 4:
            labelTitle.text = "About"
        default:
            labelTitle.text = "No Data"
        }
        return labelTitle
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
        return 35
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingsViewCell(style: .default, reuseIdentifier: nil)
        cell.contentView.isUserInteractionEnabled = false
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Please enter your first and last name."
            cell.textField.text = currenUser?.userName
        case 2:
            cell.textField.placeholder = "Please enter your job."
            cell.textField.text = currenUser?.job
        case 3:
            cell.textField.placeholder = "Please enter your age."
            if let age = currenUser?.age {
                cell.textField.text = String(age)
            }
        case 4:
            cell.textField.placeholder = "Please enter a brief information about you."
        default:
            cell.textField.placeholder = "No Data"
        }
        return cell
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let buttonSelectImage = (picker as? CustomImagePickerController)?.buttonSelectImage
        buttonSelectImage?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        buttonSelectImage?.imageView?.contentMode = .scaleAspectFill
        dismiss(animated: true)
    }
    
}

class CustomImagePickerController : UIImagePickerController {
    var buttonSelectImage : UIButton?
}

class LabelTitle : UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 15, dy: 0))
    }
}
