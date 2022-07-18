//
//  MainViewProfileView.swift
//  TinderClone
//
//  Created by Macbook Air on 18.07.2022.
//

import UIKit

class ProfileView: UIView {

    fileprivate let imgProfile = UIImageView(image: UIImage(named: "brooke-cagle-Y3L_ZQaw9Wo-unsplash.jpg"))
    let limitValue : CGFloat = 110
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(imgProfile)
        imgProfile.fillSuperView()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(catchTheProfilePicture))
        addGestureRecognizer(panGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func catchTheProfilePicture(panGesture: UIPanGestureRecognizer)  {
        
        switch panGesture.state {
        case .changed:
            catchTheChangePan(panGesture)
        case .ended:
            endPanAnimation(panGesture)
        default:
            break
        }
        
    }
    
    fileprivate func endPanAnimation(_ panGesture: UIPanGestureRecognizer) {
        
        let translationDirection : CGFloat = panGesture.translation(in: nil).x > 0 ? 1 : -1
        
        let saveProfile : Bool = abs(panGesture.translation(in: nil).x) > limitValue
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseOut) {
            if saveProfile {
                let offScreenTransform = self.transform.translatedBy(x: 600 * translationDirection, y: 0)
                self.transform = offScreenTransform
            } else {
                self.transform = .identity // merkeze (geldigi yere) konumlandirir.
            }
        } completion: { (_) in
            print("Animation finished")
            self.transform = .identity
        }
    }
    
    fileprivate func catchTheChangePan(_ panGesture: UIPanGestureRecognizer) {
        
        let translation = panGesture.translation(in: nil)
        
        let degree : CGFloat = translation.x / 10
        let radian = (degree * CGFloat.pi) / 180 // degree to radian
        
        let rotateTransform = CGAffineTransform(rotationAngle: -25) // pozitif deger sola, negatif saga dondurur.
        self.transform = rotateTransform.translatedBy(x: translation.x, y: translation.y) // .translatedBy ile mevcut olan AffineTransform'dan yeni bir transform oluşturur.
        
        /*let translation = panGesture.translation(in: nil)
        CGAffineTransform is a matrix calculator
        self.transform = CGAffineTransform(translationX: translation.x, y: translation.y)*/
    }
    

    
    
}
