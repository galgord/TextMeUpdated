//
//  addFriendsViewController.swift
//  TextMe
//
//  Created by ofir sharabi on 25/04/2019.
//  Copyright © 2019 Gal Gordon. All rights reserved.
//

import UIKit
import Firebase

class addFriendsViewController: UIViewController, UITabBarDelegate,
UITableViewDataSource, UISearchBarDelegate{
    

    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var usersArray = [User]()
    var filterdUsers = [User]()
    var friends = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        self.searchBar.isHidden = true
        self.searchBar.barTintColor = UIColor.primaryDarkColor
        self.searchBar.barStyle = .blackOpaque
        
        contactsTableView.register(userCell.self, forCellReuseIdentifier: "cell")
        fetchUser()
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onBackClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // ****************************************
    // --------- Contacts Table Methods -------
    // ****************************************
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.text != "" {
            return filterdUsers.count
        }else{
            return self.usersArray.count
        }
    }
    

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = (contactsTableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)) as! userCell
        
        cell.cellButton.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [cell.cellButton.topAnchor.constraint(equalTo: cell.topAnchor,constant: 16),
                           cell.cellButton.bottomAnchor.constraint(equalTo: cell.bottomAnchor,constant: -16),
                           cell.cellButton.trailingAnchor.constraint(equalTo: cell.trailingAnchor,constant: -16)]
        NSLayoutConstraint.activate(constraints)
        
        cell.cellButton.addTarget(cell, action: #selector(cell.onAddClicked(_:)), for: .touchUpInside)
        
        
        var user = User()
        
        if searchBar.text != "" {
            user = filterdUsers[indexPath.row]
        } else {
            user = usersArray[indexPath.row]
        }
        cell.user = user
        cell.delegate = self
        
        cell.textLabel?.text = user.displayName
        cell.detailTextLabel?.text = user.Email
        
        // Check if User in Friends Already
        for id in friends {
            if user.id == id.id {
                // Disable add friend
                cell.cellButton.isEnabled = false
                cell.cellButton.alpha = 0
            }
        }
        
        return cell
    }
    
    // User Cell
    
     class userCell : UITableViewCell {
        
        @IBOutlet var cellButton: UIButton!
  
        var user = User()
        
        var delegate : cellAddDelegate?
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
            
            // Appending Add Btn for Cell
            cellButton = UIButton(frame: CGRect(x: frame.width, y: frame.height / 2, width: 64, height: 64))
            cellButton.setImage(UIImage(named: "icons8-plus_math_filled"), for: .normal)
            cellButton.tintColor = UIColor.primaryDarkColor
            
        
            addSubview(cellButton)
        }
        
        // Delegate for Add Friend Btn
  
       @objc func onAddClicked(_ sender: UIButton) {
            // Activating Delegate Method
            delegate?.addClicked(user: user)
            // Disabling Button
            sender.isEnabled = false
        // Animation
        UIView.transition(with: sender, duration: 3, options: .curveEaseOut, animations: {
            sender.setImage(UIImage(named: "icons8-checkmark"), for: .normal)
        }) { (finished) in
            if finished {
                DispatchQueue.asyncAfter(deadline:.now() + 1.0,execute: {
                    UIView.animate(withDuration: 1.5, animations: {
                        sender.alpha = 0
                    })
                })
            }
        }
    }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    func fetchUser(){
        Database.database().reference().child("Users").observe(.childAdded) { (DataSnapshot) in
            if let dict = DataSnapshot.value as? [String:AnyObject]{
                var user = User()
                user.displayName = dict["displayName"] as! String
                user.Email = dict["email"] as! String
                user.id = dict["id"] as! String
                self.usersArray.append(user)
                self.contactsTableView.reloadData()
            }
            
        }
    }
    
    
    
    // *************************************
    // --------------- Searchbar -----------
    // *************************************
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterUsers(searchText: searchBar.text!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Filter Users Method
    
    func filterUsers(searchText : String){
        self.filterdUsers = self.usersArray.filter{
            userName in
            let user = userName.displayName
            return (user.lowercased().contains(searchText.lowercased()))
        }
        contactsTableView.reloadData()
    }
    
    // Open Search
    @IBAction func onSearchClicked(_ sender: UIButton) {
        makeSearchView()
    }
    
    @IBOutlet weak var searchHeight: NSLayoutConstraint! // searchbar height to Animate
    
    // Animating Toggle Searchbar Method
    func makeSearchView(){
        print(searchBar.isHidden)
        if !(searchBar.isHidden){
            
            self.searchHeight.constant = 0
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (status) in
                self.searchBar.isHidden = true
                
            })
        } else {
            self.searchHeight.constant = 64
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (status) in
                self.searchBar.isHidden = false
            })
        }
    }
}

// Protocol for addFriend Delegate

protocol cellAddDelegate {
    func addClicked(user: User)
}

// TODO: MAKE THIS SEND INVITE TO USERS

extension addFriendsViewController : cellAddDelegate {
    func addClicked(user: User) {
        let userId = Auth.auth().currentUser?.uid
        let dbRef = Database.database().reference().child("Users").child(userId!)
        
        let userDict = ["uid": user.id]
        dbRef.child("Friends").childByAutoId().setValue(userDict) { (error, dbRef) in
            if(error != nil){
                print(error)
            } else {
                print("user added")
            }
        }
        
//        let userDict = ["displayName": selfUser.displayName,
//                        "email": selfUser.Email,"id": selfUser.id]
//
    }
}
