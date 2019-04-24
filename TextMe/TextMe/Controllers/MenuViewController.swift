//
//  MenuViewController.swift
//  TextMe
//
//  Created by ofir sharabi on 21/04/2019.
//  Copyright © 2019 Gal Gordon. All rights reserved.
//

import UIKit
import Firebase

class MenuViewController: UIViewController, UITableViewDelegate , UITableViewDataSource, UISearchResultsUpdating {
    
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var menuBtn: UIButton!
    
    
     @IBOutlet var ContactTableView: UITableView!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    
    lazy var settingsLauncher : settingsHelper = {
        let launcher = settingsHelper()
        launcher.menuVC = self
        return launcher
    }()
    
     var usersArray = [User]()
    var filterdUsers = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLabel()
        menuBtn.setImage(UIImage(named: "icons8-menu_2"), for: .normal)
        menuBtn.tintColor = UIColor.white
       
        //create search bar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        ContactTableView.tableHeaderView = searchController.searchBar
        
        
        
      //  self.clearsSelectionOnViewWillAppear = false
        
//        self.navigationItem.rightBarButtonItem = self.editButtonItem
        ContactTableView.register(userCell.self, forCellReuseIdentifier: "cell")
        fetchUser()
        
        
    }
    
    @IBAction func onMenuCllicked(_ sender: UIButton) {
        openSettings()
    }
    
    func openSettings(){
        settingsLauncher.handleBackgroundBlur()
    }
    
    func moveToSettings(){
        
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
    // MARK: - Table view data source
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != "" {
            return filterdUsers.count
        }else{
            return self.usersArray.count
        }
            
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ContactTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var user = User()
        if searchController.isActive && searchController.searchBar.text != "" {
            
            user = filterdUsers[indexPath.row]
            
        }else{
            user = self.usersArray[indexPath.row]
            
        }
            cell.detailTextLabel?.text = user.Email
            cell.textLabel?.text = user.displayName
            return cell
            }
    
    
    
    // ROW CLICKING EVENT
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Getting User Clicked
       let user = usersArray[indexPath.row]
    
        // Passing User to Chat and Open Chat
        let storyBoard = UIStoryboard(name: "Chat", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "main") as! ChatViewController
        vc.contact = user
        self.present(vc, animated: false, completion: nil)
    }
    
    class userCell : UITableViewCell {
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
//:TODO - Add these func
   func loadLabel(){
        let nickname = Auth.auth().currentUser?.email
    
        self.nicknameLabel.text = nickname
    
}
   
    //Searchbar
    func updateSearchResults(for searchController: UISearchController) {
        filterUsers(searchText : self.searchController.searchBar.text!)
        
        
    }
    func filterUsers(searchText : String){
        self.filterdUsers = self.usersArray.filter{
            userName in
            let user = userName.displayName
            return (user.lowercased().contains(searchText.lowercased()))
        }
        ContactTableView.reloadData()
    }
        
    
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
}




    
    
