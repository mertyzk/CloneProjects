//
//  AgeRangeCell.swift
//  TinderClone
//
//  Created by Macbook Air on 23.07.2022.
//

import UIKit

class AgeRangeCell: UITableViewCell {
    
    let minSlider : UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 99
        return slider
    }()
    
    let maxSlider : UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 99
        return slider
    }()
    
    let minLabel : UILabel = {
        let label = AgeRangeCell()
        label.text = "Min 18"
        return label
    }()
    
    let maxLabel : UILabel = {
        let label = AgeRangeCell()
        label.text = "Min 18"
        return label
    }()
    
    class AgeRangeCell: UILabel {
        override var intrinsicContentSize: CGSize{
            return .init(width: 65, height: 0) // for slider - label spacing
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let minStackView = UIStackView(arrangedSubviews: [minLabel, minSlider])
        let maxStackView = UIStackView(arrangedSubviews: [maxLabel, maxSlider])
        let globalStackView = UIStackView(arrangedSubviews: [minStackView, maxStackView])
        globalStackView.axis = .vertical
        globalStackView.spacing = 15
        addSubview(globalStackView)
        //contentView.addSubview(globalStackView) ->>> ageRangeCell.contentView.isUserInteractionEnabled = false (SettingsVC - CellForRowAt Check)
        _ = globalStackView.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: .init(top: 15, left: 15, bottom: 15, right: 35))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
