//
//  MessageCell.swift
//  TextMe
//
//  Created by Gal Gordon on 20/04/2019.
//  Copyright © 2019 Gal Gordon. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    //init outlets
    @IBOutlet weak var messageBackground: UIView!
    @IBOutlet weak var userImage: UIImageView!
   // @IBOutlet weak var senderUserName: UILabel!
    @IBOutlet weak var messageBody: UILabel!
    
    
    let messageLabel = UILabel()
    let senderUserName = UILabel()
    let chatBackground = UIView()
    
    var isIncoming : Bool! {
        didSet{
            // Chat Per Sequence
            chatBackground.backgroundColor = isIncoming ? .darkGray : UIColor.primaryDarkColor
            messageLabel.textColor = isIncoming ? .white : .white
        
            // Chat Allignment
            if isIncoming {
                leadingConst.isActive = true
                trailConst.isActive = false
                
                usernameTrailConst.isActive = false
                usernameLeadingConst.isActive = true
            } else {
                leadingConst.isActive = false
                trailConst.isActive = true
                
                usernameTrailConst.isActive = true
                usernameLeadingConst.isActive = false
            }
        }
    }

    
    override func awakeFromNib() {
        
        
        
                backgroundColor = .clear
        
                addSubview(senderUserName)
        
                chatBackground.translatesAutoresizingMaskIntoConstraints = false
                chatBackground.layer.cornerRadius = 12
                // Adding chat bubble
                addSubview(chatBackground)
        
                // Adding chat Msg
                addSubview(messageLabel)
        
        
        
                messageLabel.translatesAutoresizingMaskIntoConstraints = false
                messageLabel.numberOfLines = 0
        
                senderUserName.translatesAutoresizingMaskIntoConstraints = false
                senderUserName.numberOfLines = 1
        
        // Constraints and Alignment
        let constraints = [
            senderUserName.bottomAnchor.constraint(equalTo: chatBackground.topAnchor, constant: -8),
            senderUserName.widthAnchor.constraint(lessThanOrEqualToConstant: 350),
            senderUserName.topAnchor.constraint(equalTo: topAnchor,constant: 8),
            
                           messageLabel.topAnchor.constraint(equalTo: senderUserName.bottomAnchor, constant: 32),
                           messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
                           messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
                           
            chatBackground.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
            chatBackground.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            chatBackground.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16),
            chatBackground.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16)
            ]
    
        
        
        NSLayoutConstraint.activate(constraints)
        
        leadingConst = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        trailConst = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        
        usernameLeadingConst = senderUserName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        usernameTrailConst = senderUserName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        
    }
    
    
    // **** DO NOT REMOVE OR MOVE THIS USED FOR ALIGNMENT *****
    var leadingConst: NSLayoutConstraint!
    var trailConst: NSLayoutConstraint!
    
    var usernameLeadingConst: NSLayoutConstraint!
    var usernameTrailConst: NSLayoutConstraint!
    
    
}
