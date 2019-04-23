//
//  MenuViewController.swift
//  TextMe
//
//  Created by ofir sharabi on 21/04/2019.
//  Copyright © 2019 Gal Gordon. All rights reserved.
//

import UIKit
import Firebase

class MenuViewController: UIViewController {

    @IBOutlet weak var menuBtn: UIButton!
    
    @IBOutlet weak var settingsView: UIView!
    
    @IBOutlet weak var profileBtn: UIButton!
    
    @IBOutlet weak var settingsBtn: UIButton!
    
    
    // Used for Settings
    
    lazy var settingsLauncher : settingsHelper = {
        let launcher = settingsHelper()
        launcher.menuViewController = self
        return launcher
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBtn.setImage(UIImage(named: "icons8-menu_2"), for: .normal)
        
    }
    
    // on Menu Click open
    @IBAction func onMenuCllicked(_ sender: UIButton) {
        settingsLauncher.handleBackgroundBlur()
    }
    

    // Method handling navigation on Menu Item Click
    func moveToSettings(name: String){
        
        if name == "Logout" {// Logout Clicked
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc : UIViewController = storyboard.instantiateViewController(withIdentifier: "login")
            self.show(vc, sender: self)
        }
        
        if name == "Settings" {// Settings Clicked
            let storyboard : UIStoryboard = UIStoryboard(name: "Chat", bundle: nil)
            let vc : UIViewController = storyboard.instantiateViewController(withIdentifier: "main")
            self.show(vc, sender: self)
        }
        
        if name == "Profile" {
            // Profile Clicked
        }
    }
 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//
//    func adjustViewMenu(){
//
//        settingsView.translatesAutoresizingMaskIntoConstraints = false
//
//        let constraints = [
//
//                            settingsBtn.topAnchor.constraint(equalTo: settingsView.topAnchor, constant: 32),
//                           settingsBtn.bottomAnchor.constraint(equalTo: settingsView.bottomAnchor, constant: -32),
//                           settingsBtn.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
//
//                           settingsBtn.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor,constant: 16),
//
//                           profileBtn.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor,constant: 16),
//
//                           profileBtn.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor,constant: -16),
//
//                           settingsBtn.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor,constant: -16),
//
//                           profileBtn.topAnchor.constraint(equalTo: settingsView.topAnchor, constant: 32),
//                           profileBtn.bottomAnchor.constraint(equalTo: settingsBtn.bottomAnchor, constant: -32),
//                           profileBtn.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
//
//
//
//
//                           settingsView.topAnchor.constraint(equalTo: settingsBtn.topAnchor, constant: -16),
//                           settingsView.bottomAnchor.constraint(equalTo: settingsBtn.bottomAnchor, constant: 16),
//                           settingsView.trailingAnchor.constraint(equalTo: settingsBtn.trailingAnchor, constant: 16),
//                           settingsView.leadingAnchor.constraint(equalTo: settingsBtn.leadingAnchor, constant: -16)]
//
//        NSLayoutConstraint.activate(constraints)
//    }

}
