//
//  MainViewProfileView.swift
//  TinderClone
//
//  Created by Macbook Air on 18.07.2022.
//

import UIKit
import SDWebImage

class ProfileView: UIView {

    fileprivate let imgProfile = UIImageView(image: UIImage(named: "brooke-cagle-Y3L_ZQaw9Wo-unsplash.jpg"))
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let labelUserInfo = UILabel()
    fileprivate let limitValue : CGFloat = 110
    fileprivate let notSelectedColour = UIColor(white: 0, alpha: 0.3)
    
    var userViewModel : UserProfileViewModel! {
        
        didSet {
            let imagesNames = userViewModel.imageNames.first ?? ""
            if let url = URL(string: imagesNames) {
                imgProfile.sd_setImage(with: url)
            }

            labelUserInfo.attributedText = userViewModel.attributedString
            labelUserInfo.textAlignment = userViewModel.infoLocation
            
            (0..<userViewModel.imageNames.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = notSelectedColour
                imageBarStackView.addArrangedSubview(barView)
            }
            imageBarStackView.arrangedSubviews.first?.backgroundColor = .white
            setDisplayIndexObserver()
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
        imgProfile.contentMode = .scaleAspectFill
        addSubview(imgProfile)
        imgProfile.fillSuperView()
        
        createImageBarStackView()
        
        createGradientLayer()
        
        addSubview(labelUserInfo)
        _ = labelUserInfo.anchor(top: nil,
                             bottom: bottomAnchor,
                             leading: leadingAnchor,
                             trailing: trailingAnchor,
                             padding: .init(top: 0, left: 12, bottom: 12, right: 12))
        //labelUserInfo.backgroundColor = UIColor(white: 0, alpha: 0.5)
        labelUserInfo.textColor = .white
        labelUserInfo.numberOfLines = 0
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(catchTheProfilePicture))
        addGestureRecognizer(panGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(catchTheTap))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate let imageBarStackView = UIStackView()
    
    fileprivate func setDisplayIndexObserver(){
        userViewModel.displayIndexObserver = { (index, display) in
            self.imageBarStackView.arrangedSubviews.forEach { subView in
                subView.backgroundColor = self.notSelectedColour
            }
            self.imageBarStackView.arrangedSubviews[index].backgroundColor = .white
            self.imgProfile.image = display
        }
    }
    
    fileprivate func createImageBarStackView(){
        addSubview(imageBarStackView)
        
        _ = imageBarStackView.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        imageBarStackView.spacing = 4
        imageBarStackView.distribution = .fillEqually

    }
    
    fileprivate func createGradientLayer(){
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations =  [0.5,1.0]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 350, height: 350)
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    @objc func catchTheProfilePicture(panGesture: UIPanGestureRecognizer)  {
        
        switch panGesture.state {
        case .changed:
            catchTheChangePan(panGesture)
        case .ended:
            endPanAnimation(panGesture)
        case .began:
            superview?.subviews.forEach({ subView in
                subView.layer.removeAllAnimations()
            })
        default:
            break
        }
        
    }
    
    @objc func catchTheTap(tapGesture: UITapGestureRecognizer){
       
        let tapLocation = tapGesture.location(in: nil)
        let nextDisplayTransition = tapLocation.x > frame.width / 2 ? true : false
        if nextDisplayTransition {
            userViewModel.getNextDisplay()
        } else {
            userViewModel.getPreviousDisplay()
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
            //self.transform = .identity
        }
    }
    
    fileprivate func catchTheChangePan(_ panGesture: UIPanGestureRecognizer) {
        
        let translation = panGesture.translation(in: nil)
        
        let degree : CGFloat = translation.x / 10
        _ = (degree * CGFloat.pi) / 180 // degree to radian
        
        let rotateTransform = CGAffineTransform(rotationAngle: -25) // pozitif deger sola, negatif saga dondurur.
        self.transform = rotateTransform.translatedBy(x: translation.x, y: translation.y) // .translatedBy ile mevcut olan AffineTransform'dan yeni bir transform oluşturur.
        
        /*let translation = panGesture.translation(in: nil)
        CGAffineTransform is a matrix calculator
        self.transform = CGAffineTransform(translationX: translation.x, y: translation.y)*/
    }
    

    
    
}
