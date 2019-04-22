//
//  settingsCell.swift
//  TextMe
//
//  Created by ofir sharabi on 22/04/2019.
//  Copyright © 2019 Gal Gordon. All rights reserved.
//

import UIKit




class SettingsCell: UICollectionViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){
        addSubview(nameLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
