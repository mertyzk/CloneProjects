//
//  ViewController.swift
//  TinderClone
//
//  Created by Macbook Air on 18.07.2022.
//

import UIKit

class MainViewController: UIViewController {

    //MARK: - Header menu
    let headerStackView = HeaderStackView()
    let profileMainView = UIView()
    //MARK: - Footer menu
    let bottomStackView = BottomStackView()
    
    var usersProfileViewModel : [UserProfileViewModel] = {
       let profiles = [
        User(userName: "Ahmet", job: "Mühendis", age: 25, imageNames: ["huy-phan-QCF2ykBsC2I-unsplash.jpg"]),
        User(userName: "Kerem", job: "Matematik", age: 21, imageNames: ["photo-nic-co-uk-nic-IFUwpyV8Igg-unsplash.jpg"]),
        User(userName: "Ayşe", job: "Veri uzmanı", age: 28, imageNames: ["seth-doyle-b5ul8TBY0S8-unsplash.jpg"]),
        User(userName: "Multiple User", job: "Multi photos", age: 35, imageNames: ["alisa-anton-6K4xvAMzF7Q-unsplash","allef-vinicius-_Gy8k_I2Qdw-unsplash","allef-vinicius--fyr_ZQuhGc-unsplash"]),
        Ads(title: "REKKKLAMM", brandName: "REKLAMIN MARKASI", imageName: "nathan-anderson-FHiJWoBodrs-unsplash.jpg")
    ] as [CreateProfileViewModel]
        let viewModels =  profiles.map ({ $0.createUserProfileViewModel() })
        return viewModels
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editLayout()
        setProfileScreen()
    }
    
    //MARK: - Editing layout function
    func editLayout(){
        let globalStackView = UIStackView(arrangedSubviews: [headerStackView, profileMainView, bottomStackView])
        globalStackView.axis = .vertical
        view.addSubview(globalStackView)
        globalStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                               bottom: view.safeAreaLayoutGuide.bottomAnchor,
                               leading: view.leadingAnchor,
                               trailing: view.trailingAnchor)
        
        globalStackView.isLayoutMarginsRelativeArrangement = true
        globalStackView.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
        globalStackView.bringSubviewToFront(profileMainView) // en one getirilecek subview

    }
    
    func setProfileScreen(){
        
        usersProfileViewModel.forEach { UserProfileViewModel in
            let profileView = ProfileView(frame: .zero)
            profileView.userViewModel = UserProfileViewModel
            profileMainView.addSubview(profileView)
            profileView.fillSuperView()
        }
    }


}

