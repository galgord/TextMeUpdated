//
//  ChatViewController.swift
//  TextMe
//
//  Created by Gal Gordon on 20/04/2019.
//  Copyright © 2019 Gal Gordon. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    //MARK: - Outlets and Variables
    @IBOutlet weak var chatBoxHeight: NSLayoutConstraint!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var messageText: UITextField!
    @IBOutlet weak var messageTableView: UITableView!
    var messageArray: [Message] = []
    
    @IBOutlet weak var msgField: UITextField!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Setting Btn Img
        let sendImage = UIImage(named: "icons8-sent")
        btnSend.setImage(sendImage, for: .normal)
        
        // Setting Placeholder color
        msgField.attributedPlaceholder = NSAttributedString(string:"Type something", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        //setting Protocols
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageText.delegate = self
    
        //On Load Funcs
        // configureTableView()
        retriveMessagesFromDatabase()
        messageTableView.separatorStyle = .none
        
        
        //Register Nib
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "messageCell")
        messageTableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    //MARK: - setup TableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
       cell.messageLabel.text = messageArray[indexPath.row].messageBody
        cell.senderUserName.text = messageArray[indexPath.row].sender
        
        
        // ****** TEMP COMMENT FOR UI BUILD
       // cell.senderUserName.text = messageArray[indexPath.row].sender
       // cell.userImage.image = UIImage(named: "demoUser")
        
        if cell.senderUserName.text == Auth.auth().currentUser?.email {
            //user Messages
           // cell.userImage.backgroundColor = UIColor.green
            cell.isIncoming = false
            // not user messages
        } else {
                cell.isIncoming = true
                //cell.userImage.backgroundColor = UIColor.purple
            }
 
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    
    
  
    
    //MARK: - Text Field Effects
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.chatBoxHeight.constant = 308
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func tapToClose(_ sender: Any) {
        messageText.endEditing(true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.chatBoxHeight.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func sendToDataBase(_ sender: Any) {
        //UI Fix
        messageText.endEditing(true)
        messageText.isEnabled = false
        btnSend.isEnabled = false
        
        //MARK - Saving to the Database
        let messageDB = Database.database().reference().child("Messages")
        let messageDict = ["Sender" : Auth.auth().currentUser?.email,
                          "MessageBody" : messageText.text!]
        messageDB.childByAutoId().setValue(messageDict) {
            (error,referance) in
            if error != nil{
                print(error as Any)
            }else{
                print("Message was saved to the DataBase")
                self.messageText.isEnabled = true
                self.btnSend.isEnabled = true
                self.messageText.text = ""
            }
            
        }
    }
            //MARK: - Retrive From DataBase
    func retriveMessagesFromDatabase(){
        let messageDB = Database.database().reference().child("Messages")
        messageDB.observe(.childAdded, with: { (snap) in
            let snapValue = snap.value as! Dictionary<String,String>
            let text = snapValue["MessageBody"]!
            let sender = snapValue["Sender"]!

            // linking the message
            var message = Message()
            message.messageBody = text
            message.sender = sender
            
            self.messageArray.append(message)
            self.messageTableView.reloadData()
        })
}
}


extension UIColor {
    
    static let primaryDarkColor = UIColor(red: 38, green: 191, Blue: 191, a: 1)
    
    convenience init(red: Int,green: Int,Blue: Int, a: CGFloat = 1.0) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0 , blue: CGFloat(Blue) / 255.0, alpha: a)
    }
    
    
    
    }

