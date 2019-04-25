//
//  settingsHelper.swift
//  TextMe
//
//  Created by ofir sharabi on 22/04/2019.
//  Copyright © 2019 Gal Gordon. All rights reserved.
//

import UIKit


class settingsHelper : NSObject, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    // Vars
    
    let blackView = UIView() // TransperncyView
    
    var menuVC = MenuViewController() // PreviousViewController
    
    // Collection View of Settings
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    // Cell of settings height
    let cellHeight: CGFloat = 64
    
    // Array of Settings
    var settings: [Setting] = {
        return [Setting(name: "Settings", imageName: "icons8-settings_filled-1"),
                Setting(name: "Profile",imageName: "icons8-user_filled"),
                Setting(name: "Logout",imageName: "icons8-logout_rounded_up_filled")]
    }()
    
    //Init
    
    override init() {
        super.init()
        // Registering Collection View
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(SettingsCell.self, forCellWithReuseIdentifier: "settingsCell")
    }
    
    
    
    // Open Settings
    
    func handleBackgroundBlur(){
        
        if let window = UIApplication.shared.keyWindow {
            self.blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDissmissBlur)))
            
            window.addSubview(blackView)
            
            
            window.addSubview(collectionView)
            
            
            let height: CGFloat = CGFloat(settings.count)  * cellHeight + 15
            let y = window.frame.height - height
            
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            collectionView.backgroundColor = UIColor.white
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
        }
    }
    
    // Dissmising Settings
     @objc func handleDissmissBlur(){
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }
    }
    
    
    // *********************************************
    // --------- Collection View Methods -----------
    // *********************************************
    
    //Number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    // Binding Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "settingsCell", for: indexPath) as! SettingsCell
        
        let setting = settings[indexPath.item]
        cell.setting = setting
        
        return cell
    }
    
    
    // Sizing Cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    // Reduce LineSpacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // On Settings Clicked
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let setting = settings[indexPath.row]
        menuVC.moveToSettings(settingName: setting.name)
    }
    
    
}
