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
    
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var msgField: UITextField!
    
    var contact : User = User()
    
    var chatId : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIBuild()
        
        //setting Protocols
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageText.delegate = self
    
        //On Load Funcs
        retriveMessagesFromDatabase()
        messageTableView.separatorStyle = .none
        
        messageTableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        //Register Nib
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "messageCell")
    // Enables Table Delete Button
    messageTableView.allowsSelectionDuringEditing = true
        
    }
    
    func UIBuild(){
        
        // Setting UI
        let sendImage = UIImage(named: "icons8-sent")
        btnSend.setImage(sendImage, for: .normal)
        
        contactNameLabel.text = contact.displayName
        
        // Setting Placeholder color
        msgField.attributedPlaceholder = NSAttributedString(string:"Type something", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    // ****************************************
    // --------- Massages Table Methods -------
    // ****************************************
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("Messages").child(uid!)
        self.messageArray.remove(at: indexPath.row)
        self.messageTableView.deleteRows(at: [indexPath], with: .automatic)
        print("did I get here?")
        //                 self.retriveMessagesFromDatabase()
    }
    
    
    @IBAction func tapToClose(_ sender: Any) {
        messageText.endEditing(true)
    }

    @IBAction func sendToDataBase(_ sender: Any) {
        //UI Fix
        messageText.endEditing(true)
        messageText.isEnabled = false
        btnSend.isEnabled = false
    
        
        // Setting OneToOne Chat ID
        if(contact.id < (Auth.auth().currentUser?.uid)!){
            chatId = contact.id+(Auth.auth().currentUser?.uid)!
        } else {
            chatId = (Auth.auth().currentUser?.uid)! + contact.id
        }
        
        //MARK - Saving to the Database
        let messageDB = Database.database().reference().child("Chats").child(chatId)
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
    
        // Getting id of OneToOne Chat ID
        if(contact.id < (Auth.auth().currentUser?.uid)!){
            chatId = contact.id+(Auth.auth().currentUser?.uid)!
        } else {
            chatId = (Auth.auth().currentUser?.uid)! + contact.id
        }
        
        let messageDB = Database.database().reference().child("Chats").child(chatId)
        messageDB.observe(.childAdded, with: { (snap) in
            let snapValue = snap.value as! Dictionary<String,String>
            let text = snapValue["MessageBody"]!
            let sender = snapValue["Sender"]!
            
            
            // linking the message
            var message = Message()
            message.messageBody = text
            message.sender = sender
            
            // Checking for User massages
            if(message.sender == self.contact.Email || message.sender == Auth.auth().currentUser?.email) {
            
            self.messageArray.append(message)
            self.messageTableView.reloadData()
            }
        })
    }
    
    @IBAction func onBackClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

