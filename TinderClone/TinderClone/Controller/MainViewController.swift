//
//  ViewController.swift
//  TinderClone
//
//  Created by Macbook Air on 18.07.2022.
//

import UIKit
import Firebase
import JGProgressHUD

class MainViewController: UIViewController {
    
    //MARK: - Header menu
    let headerStackView = HeaderStackView()
    //MARK: - Middle Area (Profile Area)
    let profileMainView = UIView()
    //MARK: - Footer menu
    let bottomStackView = BottomStackView()
    
    var usersProfileViewModel : [UserProfileViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerStackView.profileButton.addTarget(self, action: #selector(pressSettingsButton), for: .touchUpInside)
        bottomStackView.refreshButton.addTarget(self, action: #selector(pressRefreshButton), for: .touchUpInside)
        
        editLayout()
        setUserProfilesFireStore()
        getByUserInfoFromFirestore()
        //tryLogin()
    }
    
    fileprivate func tryLogin(){
        Auth.auth().signIn(withEmail: "denemegirisi@hotmail.com", password: "123123123")
        print("oTURUM AÇILDI")
    }
    
    //MARK: - Editing layout function
    func editLayout(){
        view.backgroundColor = .white
        let globalStackView = UIStackView(arrangedSubviews: [headerStackView, profileMainView, bottomStackView])
        globalStackView.axis = .vertical
        view.addSubview(globalStackView)
        _ = globalStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                               bottom: view.safeAreaLayoutGuide.bottomAnchor,
                               leading: view.leadingAnchor,
                               trailing: view.trailingAnchor)
        
        globalStackView.isLayoutMarginsRelativeArrangement = true
        globalStackView.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
        globalStackView.bringSubviewToFront(profileMainView) // en one getirilecek subview

    }
    
    @objc func pressSettingsButton(){
        let settingsVC = SettingsViewController()
        let navigationController = UINavigationController(rootViewController: settingsVC)
        present(navigationController, animated: true)
        
    }
    
    @objc func pressRefreshButton(){
        getByUserInfoFromFirestore()
    }
    
    
    var lastIncomingUser : User?
    
    func getByUserInfoFromFirestore(){
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching Profiles..."
        hud.show(in: view)
        let query = Firestore.firestore().collection("Users")//.whereField("Age", isEqualTo: 25)
            .order(by: "UserID") // UserID alanına gore hepsini siralar.
            .start(at: [lastIncomingUser?.userID ?? ""]) // son getirilen kullanicinin kullanici ID'sinden itibaren siralamaya baslar.
            .limit(to: 2) // uygulama acildiginda 2 tane gelir.
        query.getDocuments { snapshot, error in
            hud.dismiss()
            if let error = error {
                print("kullanıcılar getirilriken hata oluştu: \(error)")
                return
            }
            
            snapshot?.documents.forEach({ documentSnapshot in
                let userData = documentSnapshot.data()
                let user = User(infos: userData)
                self.usersProfileViewModel.append(user.createUserProfileViewModel())
                self.lastIncomingUser = user
                self.createProfileFromUser(user: user)
            })
            
            //self.setUserProfilesFireStore()
            
        }
    }
    
    fileprivate func createProfileFromUser(user: User){
        let profileView = ProfileView(frame: .zero)
        profileView.userViewModel = user.createUserProfileViewModel()
        profileMainView.addSubview(profileView)
        profileView.fillSuperView()
    }
    
    func setUserProfilesFireStore(){
        
        usersProfileViewModel.forEach { UserProfileViewModel in
            let profileView = ProfileView(frame: .zero)
            profileView.userViewModel = UserProfileViewModel
            profileMainView.addSubview(profileView)
            profileView.fillSuperView()
        }
        
    }
    

}

