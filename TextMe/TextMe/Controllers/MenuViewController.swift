//
//  MenuViewController.swift
//  TextMe
//
//  Created by ofir sharabi on 21/04/2019.
//  Copyright © 2019 Gal Gordon. All rights reserved.
//

import UIKit
import Firebase




// ****************************************************
// --------------- CONTACTS VIEW CONTROLLER -----------
// ****************************************************


class MenuViewController: UIViewController, UITableViewDelegate , UITableViewDataSource, UISearchBarDelegate {
   
    
    
    // Vars
    
   
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var menuBtn: UIButton!
    
     @IBOutlet var ContactTableView: UITableView!
    @IBOutlet weak var toolbarView: UIView!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    
    @IBOutlet weak var searchBarBtn: UIButton!
    
    @IBOutlet weak var searchBarView: UIView!
    
    lazy var settingsLauncher : settingsHelper = {
        let launcher = settingsHelper()
        launcher.menuVC = self
        return launcher
    }()
    
     var usersArray = [User]()
    var filterdUsers = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UIBuild()
        self.searchBar.delegate = self
        
        menuBtn.setImage(UIImage(named: "icons8-menu_2"), for: .normal)
        menuBtn.tintColor = UIColor.white
        
        // Registering Contacts
        ContactTableView.register(userCell.self, forCellReuseIdentifier: "cell")
        fetchUser()
    }
    
     func dismissSearch(){
    }
    
    @IBAction func onMenuCllicked(_ sender: UIButton) {
        settingsLauncher.handleBackgroundBlur()
    }
    
    
    func UIBuild(){
        
        //Nickname label
        let nickname = Auth.auth().currentUser?.email
        self.nicknameLabel.text = nickname
        
        self.searchBar.isHidden = true
        self.searchBar.barTintColor = UIColor.primaryDarkColor
        self.searchBar.barStyle = .blackOpaque
        
        menuBtn.setImage(UIImage(named: "icons8-menu_2"), for: .normal)
        menuBtn.tintColor = UIColor.white
        
    }
    
    // On Settings Clicked
    func moveToSettings(settingName: String){
        if(settingName == "Logout"){
            try! Auth.auth().signOut()
            
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc : UIViewController =  storyboard.instantiateViewController(withIdentifier: "Login")
                self.show(vc, sender: self)
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
                self.ContactTableView.reloadData()
            }
            
        }
    }
    
    
    // ****************************************
    // --------- Contacts Table Methods -------
    // ****************************************

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if !searchBar.isHidden && searchBar.text != "" {
            return filterdUsers.count
        }else{
            return self.usersArray.count
        }
            
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ContactTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var user = User()
        if searchBar.text != "" {
            
            user = filterdUsers[indexPath.row]
            
        }else{
            user = self.usersArray[indexPath.row]
            
        }
        cell.detailTextLabel?.text = user.Email
        cell.textLabel?.text = user.displayName
        return cell
    }
    
    
    
    // Table User on Click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselcet Row
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Getting User Clicked
        
        var user = User()
        
        if searchBar.text != "" {
            
            user = filterdUsers[indexPath.row]
        }else{
            user = self.usersArray[indexPath.row]
            
        }
        
        // Passing User to Chat and Open Chat
        let storyBoard = UIStoryboard(name: "Chat", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "main") as! ChatViewController
        vc.contact = user
        self.present(vc, animated: false, completion: nil)
    }
    
    // User Cell
    
    class userCell : UITableViewCell {
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
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
    
    func filterUsers(searchText : String){
        self.filterdUsers = self.usersArray.filter{
            userName in
            let user = userName.displayName
            return (user.lowercased().contains(searchText.lowercased()))
        }
        ContactTableView.reloadData()
    }
    
    @IBAction func openSearchView(_ sender: UIButton) {
            makeSearchView()
    }
    
    @IBOutlet weak var searchHeight: NSLayoutConstraint!
    
    func makeSearchView(){
        
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
        
//             UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//
//                if !(self.searchBar.isHidden) {
//                    self.searchBarView.frame = CGRect(x: 0, y: self.toolbarView.frame.height, width: self.searchBar.frame.width, height: self.searchBar.frame.height)
//                } else {
//                    self.searchBarView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 50)
//                }
//            }) { (finsihed) in
//
//                if(self.searchBar.isHidden){
//                    self.searchBar.isHidden = false
//                self.ContactTableView.tableHeaderView = self.searchBar
//                } else {
//                    self.searchBar.isHidden = true
//                    self.ContactTableView.tableHeaderView = nil
//                }
//            }
    
    /*@IBAction func pickProfilePic(_ sender: Any) {
     let pick = UIImagePickerController()
     pick.delegate = self
     present(pick, animated: true, completion: nil)
     }
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
     profilePicture.image = image
     self.dismiss(animated: true, completion: nil)
     }*/





    
    
