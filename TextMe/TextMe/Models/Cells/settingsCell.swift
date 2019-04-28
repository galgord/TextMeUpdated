//
//  settingsCell.swift
//  TextMe
//
//  Created by ofir sharabi on 22/04/2019.
//  Copyright © 2019 Gal Gordon. All rights reserved.
//

import UIKit


class Setting : NSObject {
    let name : String
    let imageName: String
    
    init(name: String,imageName: String) {
        
        self.name = name
        self.imageName = imageName
    }
}

class SettingsCell: UICollectionViewCell {
    
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .primaryDark : UIColor.white
            
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            
            iconImage.tintColor = isHighlighted ? UIColor.white : UIColor.darkGray
        }
    }
    
    var setting: Setting? {
        didSet{
            nameLabel.text = setting?.name
            
            if let imageName = setting?.imageName {
                iconImage.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
                iconImage.tintColor = UIColor.darkGray
            }
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icons8-menu_2")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){
        addSubview(nameLabel)
        addSubview(iconImage)
        
        addConstraintWithFormat("H:|-8-[v0(30)]-8-[v1]|", views: iconImage,nameLabel)
        addConstraintWithFormat("V:|[v0]|", views: nameLabel)
        
        addConstraintWithFormat("V:[v0(30)]", views: iconImage)
        
        
        
        
        addConstraint(NSLayoutConstraint(item: iconImage, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension UIView{
    func addConstraintWithFormat(_ format : String, views : UIView...) {
        
        var viewsDictionary = [String : UIView]()
        
        for(index, view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
        
 }
}
