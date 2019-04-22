//
//  RegisterViewController.swift
//  TextMe
//
//  Created by ofir sharabi on 20/04/2019.
//  Copyright © 2019 Gal Gordon. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
class RegisterViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var displayNameTextField: UITextField!
    
    @IBOutlet weak var emailValidLabel: UILabel!
    @IBOutlet weak var passValidLabel: UILabel!
    @IBOutlet weak var displayNameValidLabel: UILabel!
    
    @IBOutlet weak var msgLabel: UILabel!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        UIBuild()
    }

    
    // Back to Login
    @IBAction func onBackClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    // Method adding Drawable to TextField
    func addImageTo(textField: UITextField,Image img: UIImage){
        let rightImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height))
        rightImageView.image = img
        textField.rightView = rightImageView
        textField.rightView?.layoutMargins.right = 32
        textField.rightViewMode = .always
    }
    
    func UIBuild(){
        
        // Adding Underlines
        emailTextField.underlined(UIColor.white)
        passTextField.underlined(UIColor.white)
        displayNameTextField.underlined(UIColor.white)
        
        
        // Changing placeholder Color
        emailTextField.attributedPlaceholder = NSAttributedString(string:"Email:", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passTextField.attributedPlaceholder = NSAttributedString(string:"Password:", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        displayNameTextField.attributedPlaceholder = NSAttributedString(string:"Nickname:", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        
        
        // Adding Images to TextFields
        let emailImage = UIImage(named: "icons8-email")
        addImageTo(textField: emailTextField, Image: emailImage!)
        
        let passwordImage = UIImage(named: "icons8-password")
        addImageTo(textField: passTextField, Image: passwordImage!)
        
        let displayNameImage = UIImage(named: "icons8-guest_male")
        addImageTo(textField: displayNameTextField, Image: displayNameImage!)
        
        self.msgLabel.textColor = UIColor.red
        
    }
    
    
    //Method used to Validate Register Form
    func validation(pass: String, nickname: String) -> Bool{
        //Validating Email
        if(!emailTextField.isValidEmail()){
            emailValidLabel.text = "Invalid Email"
            UIView.animate(withDuration: 0.8) {
                self.emailValidLabel.alpha = 1.0
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    UIView.animate(withDuration: 0.8, animations: {
                        self.emailValidLabel.alpha = 0.0
                    })
                })
            }
        }
        // Validating Password
        if passTextField.text == "" || (passTextField.text?.count)! < 8 {
            passValidLabel.text = "Password must contains atleast 8 characters"
            UIView.animate(withDuration: 0.8) {
                self.passValidLabel.alpha = 1.0
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    UIView.animate(withDuration: 0.8, animations: {
                        self.passValidLabel.alpha = 0.0
                    })
                })
            }
        }
        
        //Validating Nickname
        
        if displayNameTextField.text == "" || (displayNameTextField.text?.count)! == 0 {
            displayNameValidLabel.text = "Name Required"
            
            UIView.animate(withDuration: 0.8) {
                self.displayNameValidLabel.alpha = 1.0
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    UIView.animate(withDuration: 0.8, animations: {
                        self.displayNameValidLabel.alpha = 0
                    })
                })
            }
        }
        
        if(displayNameTextField.text == "" || (passTextField.text?.count)! < 8 || !emailTextField.isValidEmail()){
            return false
        } else {
        return true
        }
    }
    
    // On Register Click
    @IBAction func onRegisterClicked(_ sender: UIButton) {
        
        if !validation(pass: passTextField.text!, nickname: displayNameTextField.text!){
            return
        } else {
            
             SVProgressHUD.show()
            // Mark: - Register User
            let firebaseAuth = Auth.auth()
            firebaseAuth.createUser(withEmail: emailTextField.text!, password: passTextField.text!) {[weak self] user , error in
                guard let strongSelf = self else {return}
                
                if error != nil {
                    // Mark: - Error
                    let errorDesc : String? = error?.localizedDescription
                    
                    strongSelf.msgLabel.text = errorDesc
                    UIView.animate(withDuration: 0.8, animations: {
                        strongSelf.msgLabel.alpha = 1
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            strongSelf.msgLabel.alpha = 0.0
                        })
                        SVProgressHUD.dismiss()
                    })
                } else {
                    // Mark - Register Succed
                    
                    // Setting Profile Name
                    firebaseAuth.currentUser?.createProfileChangeRequest().displayName?.append(contentsOf: self?.displayNameTextField.text ?? "")
                    
                    // Creating User
                    var user : User = User()
                    user.id = firebaseAuth.currentUser?.uid ?? ""
                    user.Email = self?.emailTextField.text! ?? ""
                    user.displayName = self?.displayNameTextField.text! ?? ""
                    
                    // Writing User to Database
                    let ref = Database.database().reference()
                    ref.child("Users").child(user.id).setValue(["email": user.Email,"displayName": user.displayName,"id": user.id])
                    
                        strongSelf.msgLabel.textColor = UIColor.blue
                        strongSelf.msgLabel.text = "Registration Success"
                    
                    UIView.animate(withDuration: 0.8, animations: {
                        strongSelf.msgLabel.alpha = 1
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            strongSelf.msgLabel.alpha = 0
                        })
                    })
                
                    // Back to Login
                    SVProgressHUD.dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                        strongSelf.dismiss(animated: true)}
                )
            }
            }
        }
    }
    
    
}



