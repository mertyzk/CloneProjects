//
//  ViewController.swift
//  TinderClone
//
//  Created by Macbook Air on 18.07.2022.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - Header menu
    let headerStackView = HeaderStackView()
    let profileMainView = UIView()
    //MARK: - Footer menu
    let bottomStackView = BottomStackView()
    
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
        
        let profileView = ProfileView(frame: .zero)
        profileMainView.addSubview(profileView)
        profileView.fillSuperView()
        
    }


}

