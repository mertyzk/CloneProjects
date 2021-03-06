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
    
    var delegate: SettingsViewControllerDelegate?
    
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
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutButtonPressed)), UIBarButtonItem(title: "Save Data", style: .done, target: self, action: #selector(saveInfoButtonPressed))]
    }
    
    @objc fileprivate func cancelButtonPressed(){
        //Close view
        dismiss(animated: true)
    }
    
    @objc fileprivate func saveInfoButtonPressed(){
        // Current data saves to Firebase
        
        let saveDataHud = JGProgressHUD(style: .dark)
        saveDataHud.textLabel.text = "Saving datas.."
        saveDataHud.show(in: view)
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let datas : [String : Any] = [
            "UserID" : uid,
            "NameSurname" : currentUser?.userName ?? "No Name Surname",
            "ImageURL" : currentUser?.imageURL1 ?? "",
            "ImageURL2" : currentUser?.imageURL2 ?? "",
            "ImageURL3" : currentUser?.imageURL3 ?? "",
            "Age" : currentUser?.age ?? -1,
            "Job" : currentUser?.job ?? "NULL",
            "MinimumAge" : currentUser?.searchMinAge ?? -1,
            "MaximumAge" : currentUser?.searchMaxAge ?? -1
        ]
        Firestore.firestore().collection("Users").document(uid).setData(datas) { error in
            saveDataHud.dismiss()
            if let error = error {
                print("Error saving users data \(error.localizedDescription)")
                return
            }
            print("User data saved successfully.")
            self.dismiss(animated: true) {
                //mainViewController.getByCurrentUser() ihtiyacimiz var. Delegate icin -> en altta protocol SettingsViewControllerDelegate olusturup fonksiyonumuzu yazdik.
                //en ustte var delegate: SettingsViewControllerDelegate? nesnesini olusturduk.
                self.delegate?.settingsSaved() // User data saved successfully sonras??nda delegate kimse, settingSaved fonksiyonu cal??ss??n.
            }
        }
    }
    
    @objc fileprivate func logoutButtonPressed(){
        // Logout of the profile
        print("Oturum kapat??l??yor.")
        try? Auth.auth().signOut() //logout
        dismiss(animated: true, completion: nil)
    }
    

    
    @objc fileprivate func selectImageButtonPressed(button: UIButton) {
    
        let imagePicker = CustomImagePickerController()
        imagePicker.buttonSelectImage = button
        imagePicker.delegate = self
        present(imagePicker,animated: true)
    }
    
    var currentUser : User?
    
    fileprivate func getByUserInfo(){
        
        // Hem SettingsViewController (getByUserInfo fonksiyonu) ve hemde MainViewController'da (getByCurrentUser fonksiyonu) ile veri getirme ihtiyac??m??z oldu.
        // Bunun icin Firebase'e bir extension yaziyoruz. (Extensions+Firestore)
        /*guard let uid = Auth.auth().currentUser?.uid else {// extensions -> Extensions+Firestore yazildi.
            return// extensions -> Extensions+Firestore yazildi.
        }// extensions -> Extensions+Firestore yazildi.
         // extensions -> Extensions+Firestore yazildi.
        Firestore.firestore().collection("Users").document(uid).getDocument { snapshot, fault in// extensions -> Extensions+Firestore yazildi.
            if let fault = fault {
                print("kullan??c?? bilgileri getirilirken hata: \(fault)")// extensions -> Extensions+Firestore yazildi.
                return
            }// extensions -> Extensions+Firestore yazildi.
         // extensions -> Extensions+Firestore yazildi.
            guard let datas = snapshot?.data() else { return }
            self.currenUser = User(infos: datas)
            self.loadProfilePictures()
            self.tableView.reloadData()
        }*/
        
        Firestore.firestore().getByCurrentUser { user, error in
            if let error = error {
                print("Oturum a??an kullan??c?? bilgileri getirilken hata meydana geldi \(error)")
                return
            }
            self.currentUser = user
            self.loadProfilePictures()
            self.tableView.reloadData()
        }
    }

    
    fileprivate func loadProfilePictures(){
        
        guard let imageURL = currentUser?.imageURL1, let url = URL(string: imageURL) else {
            return
        }
        
        SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { image, _, _, _, _, _ in
            self.selectionArea1.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        guard let imageURL2 = currentUser?.imageURL2, let url2 = URL(string: imageURL2) else {
            return
        }
        
        SDWebImageManager.shared().loadImage(with: url2, options: .continueInBackground, progress: nil) { image, _, _, _, _, _ in
            self.selectionArea2.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        guard let imageURL3 = currentUser?.imageURL3, let url3 = URL(string: imageURL3) else {
            return
        }
        
        SDWebImageManager.shared().loadImage(with: url3, options: .continueInBackground, progress: nil) { image, _, _, _, _, _ in
            self.selectionArea3.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    @objc fileprivate func catchTheNameTextFieldChange(textField : UITextField){
        self.currentUser?.userName = textField.text
    }
    
    @objc fileprivate func catchTheJobTextFieldChange(textField : UITextField){
        self.currentUser?.job = textField.text
    }
    
    @objc fileprivate func catchTheAgeTextFieldChange(textField : UITextField){
        self.currentUser?.age = Int(textField.text ?? "")
    }
    
    @objc fileprivate func minAgeSliderChange(value: UISlider){
        
        setMinMaxSlider()
        /*let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as? AgeRangeCell
        ageRangeCell?.minLabel.text = "Min \(Int(value.value))"
        currenUser?.searchMinAge = Int(value.value)*/ //-->> setMinMaxSlider() function
    }
    
    @objc fileprivate func maxAgeSliderChange(value: UISlider){
        
        setMinMaxSlider()
        /*let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as? AgeRangeCell
        ageRangeCell?.maxLabel.text = "Max \(Int(value.value))"
        currenUser?.searchMaxAge = Int(value.value)*/ //-->> setMinMaxSlider() function
    }
    
    fileprivate func setMinMaxSlider(){
        
        guard let ageRangeCell = tableView.cellForRow(at: [5,0]) as? AgeRangeCell else { return } // 5. section 0. index
        let minValue = Int(ageRangeCell.minSlider.value)
        var maxValue = Int(ageRangeCell.maxSlider.value)
        
        maxValue = max(minValue, maxValue) // hangisi daha buyukse, maksimum deger minimum degere esit olacak bunu saglayacagiz.
        ageRangeCell.maxSlider.value = Float(maxValue)
        ageRangeCell.minLabel.text = "Min \(minValue)"
        ageRangeCell.maxLabel.text = "Max \(maxValue)"
        
        currentUser?.searchMinAge = minValue
        currentUser?.searchMaxAge = maxValue
        
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
        case 5:
            labelTitle.text = "Age Range"
        default:
            labelTitle.text = "No Data"
        }
        labelTitle.font = UIFont.boldSystemFont(ofSize: 18)
        return labelTitle
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
        return 35
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 5 {
            let ageRangeCell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            ageRangeCell.minSlider.addTarget(self, action: #selector(minAgeSliderChange), for: .valueChanged)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(maxAgeSliderChange), for: .valueChanged)
            ageRangeCell.contentView.isUserInteractionEnabled = false
            
            ageRangeCell.minLabel.text = "Min \(currentUser?.searchMinAge ?? 18)"
            ageRangeCell.minSlider.value = Float(currentUser?.searchMinAge ?? 18)
            ageRangeCell.maxLabel.text = "Min \(currentUser?.searchMaxAge ?? 18)"
            ageRangeCell.maxSlider.value = Float(currentUser?.searchMaxAge ?? 18)
            
            
            return ageRangeCell
        }
        let cell = SettingsViewCell(style: .default, reuseIdentifier: nil)
        cell.contentView.isUserInteractionEnabled = false
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Please enter your first and last name."
            cell.textField.text = currentUser?.userName
            cell.textField.addTarget(self, action: #selector(catchTheNameTextFieldChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Please enter your age."
            cell.textField.keyboardType = .numberPad
            if let age = currentUser?.age {
                cell.textField.text = String(age)
                cell.textField.addTarget(self, action: #selector(catchTheAgeTextFieldChange), for: .editingChanged)
            }
        case 3:
            cell.textField.placeholder = "Please enter your job."
            cell.textField.text = currentUser?.job
            cell.textField.addTarget(self, action: #selector(catchTheJobTextFieldChange), for: .editingChanged)
        case 4:
            cell.textField.placeholder = "Please enter a brief information about you."
        default:
            cell.textField.placeholder = "No Data"
        }
        return cell
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let buttonSelectImage = (picker as? CustomImagePickerController)?.buttonSelectImage // hangi butona tikland??ysa buttonSelectImage'a o atan??r.
        buttonSelectImage?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        buttonSelectImage?.imageView?.contentMode = .scaleAspectFill
        dismiss(animated: true)
        
        let imageName = UUID().uuidString // Firestore'a kaydetmek icin rastgele uuid
        let referance = Storage.storage().reference(withPath: "/images/\(imageName)")
        
        guard let data = selectedImage?.jpegData(compressionQuality: 0.8) else { return }
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading.."
        hud.show(in: view)
        referance.putData(data, metadata: nil) { _, error in
            if error != nil {

                print("Image uploading error: \(error?.localizedDescription)")
                return
            }
            print("Upload is success")
            referance.downloadURL { url, error in
                hud.dismiss()
                if let error = error {
                    print("URL al??namad??")
                    return
                }
                print("URL ba??ar??yla al??nd?? : ***** \(url?.absoluteString)")
                switch buttonSelectImage {
                case self.selectionArea1:
                    self.currentUser?.imageURL1 = url?.absoluteString
                case self.selectionArea2:
                    self.currentUser?.imageURL2 = url?.absoluteString
                case self.selectionArea3:
                    self.currentUser?.imageURL3 = url?.absoluteString
                default:
                    print("data")
                }
            }
        }
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

protocol SettingsViewControllerDelegate {
    func settingsSaved()
}
