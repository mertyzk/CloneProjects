//
//  ICTabBarController.swift
//  InstaClone
//
//  Created by Macbook Air on 21.10.2022.
//

import UIKit

class ICTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewLayout()
        let userProfileVC = UserProfileVC(collectionViewLayout: layout)
        let navigationController = UINavigationController(rootViewController: userProfileVC)
        navigationController.tabBarItem.image = UIImage(systemName: "person")?.withRenderingMode(.alwaysOriginal)
        navigationController.tabBarItem.selectedImage = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysOriginal)
        viewControllers = [navigationController]

    }

}
