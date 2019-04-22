//
//  ViewController.swift
//  TextMe
//
//  Created by Gal Gordon on 19/04/2019.
//  Copyright © 2019 Gal Gordon. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ViewController: UIViewController {
    
    // Views
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var phoneValidLabel: UILabel!
    
    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var passValidLabel: UILabel!
    
    
    @IBOutlet weak var msgLabel: UILabel!
    
    
    @IBOutlet weak var facebookBtn: UIButton!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var googleBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIFixing()
        
        if Auth.auth().currentUser != nil {
            moveToMain()
        }
    }
    
    // Method adding Drawable to TextField
    func addImageTo(txtField: UITextField, andImage img: UIImage){
        let rightImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height))
        rightImageView.image = img
        txtField.rightView = rightImageView
        txtField.rightView?.layoutMargins.right = 32
        txtField.rightViewMode = .always
    }
    
    
    //Setting UI Build Fixes
    func UIFixing(){
        
        
        // Setting Square Button
        loginBtn.layer.cornerRadius = 7.5
        loginBtn.layer.masksToBounds = true
        
        facebookBtn.layer.cornerRadius = 2.5
        facebookBtn.layer.masksToBounds = true
        
        googleBtn.layer.cornerRadius = 2.5
        googleBtn.layer.masksToBounds = true
        
        // Setting underline Text Field
        phoneTextField.underlined(UIColor.white)
        passTextField.underlined(UIColor.white)
        
        // Changing placeholder Color
        phoneTextField.attributedPlaceholder = NSAttributedString(string:"Email:", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passTextField.attributedPlaceholder = NSAttributedString(string:"Password:", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        // Adding Image to TextFields
        let phoneImage = UIImage(named: "icons8-email")
        addImageTo(txtField: phoneTextField, andImage: phoneImage!)
        
        let passImage = UIImage(named: "icons8-password")
        addImageTo(txtField: passTextField, andImage: passImage!)
        
        
        self.msgLabel.textColor = UIColor.red
       
    }
    
    
    //Moving to Main Storyboard
    func moveToMain(){
        let storyboard : UIStoryboard = UIStoryboard(name: "Chat", bundle: nil)
        let vc : UIViewController = storyboard.instantiateViewController(withIdentifier: "menu")
        self.show(vc, sender: self)
    }
    
    

    // on Login Clicked
    @IBAction func onRegisterClicked(_ sender: UIButton) {
        // Check for Validation
        if(!Validation(email: phoneTextField.text!, password: passTextField.text!)){
            return
        }
        // Showing Progress Bar
        SVProgressHUD.show()
        
        // Preform Login
        Auth.auth().signIn(withEmail: phoneTextField.text!, password: passTextField.text!) { [weak self] user , error in
            guard let strongSelf = self else { return }
            
            
            // Checking for Error
            if(error != nil){
                strongSelf.msgLabel.text = error?.localizedDescription
                
                UIView.animate(withDuration: 0.8, animations: {
                    strongSelf.msgLabel.alpha = 1.0
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                        strongSelf.msgLabel.alpha = 0.0
                    })
                    SVProgressHUD.dismiss() // Dissmising Progress Bar
                })
            } else { // NO ERRORS
                // Login User
                strongSelf.msgLabel.text = "Login Successfuly"
                strongSelf.msgLabel.textColor = UIColor.blue
                UIView.animate(withDuration: 0.8, animations: {
                    strongSelf.msgLabel.alpha = 1.0
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    UIView.animate(withDuration: 0.8, animations: {
                        strongSelf.msgLabel.alpha = 0.0
                    })
                    SVProgressHUD.dismiss()
                    strongSelf.moveToMain()
                })
            }
        }
   }
    
    
    // Used for a Login Validation
    func Validation(email: String,password: String) -> Bool{
        
        //Password Validation
        if password.count <= 0 {
            UIView.animate(withDuration: 0.8) {
                self.passValidLabel.alpha = 1.0
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    UIView.animate(withDuration: 0.8, animations: {
                        self.passValidLabel.alpha = 0.0
                    })
                })
            }
        }
        
        // Email Validation
        if(!phoneTextField.isValidEmail()){
            phoneValidLabel.text = "Invalid email"
            UIView.animate(withDuration: 0.8) {
                self.phoneValidLabel.alpha = 1.0
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    self.phoneValidLabel.alpha = 0.0
                })
            }
        }
        
        if(!phoneTextField.isValidEmail() || password.count == 0 || password == ""){
            return false // Validation Failed
        } else {return true /* Validation Succed */}
    }
}


// --- Extansion used for a Textfield Underline Method ---

extension UITextField {
    func underlined(_ color : UIColor){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.width)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    // Used for Email Regex
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.text)
    }
}

