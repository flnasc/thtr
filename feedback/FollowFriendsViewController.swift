//
//  FollowFriendsViewController.swift
//  feedback
//
//  Created by Nicole Nigro on 6/17/20.
//  Copyright © 2020 James Little. All rights reserved.
//

/*
 Precondition: U. is logged in

 Main Flow:
 [X] U. selects Follow Friends Option
 [X] The list of current users screen name is displayed
 [X] U. selects one or more friends
 [X] U. selects "Follow"

 Extensions:
 - Filtering
    - User can type parts of user name
    - The list of friends shall be filter, and display only contact names containing the search string

 Post-Condition: An invitation is sent to all selected contacts
 */

import UIKit
import Firebase
import FirebaseDatabase

class FollowFriendsViewController: UITableViewController{
    
    var usernames: [String] = []
    var usersToFollow: [String] = []
    
    var following: [String] = []
    var pending: [String] = []
    
    var thisUsername = String()
    
    lazy var profileButton = UIBarButtonItem(
        image: UIImage(named: "account"),
        style: .plain,
        target: self,
        action: #selector(displayAccountViewController(sender:))
    )

    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.tableFooterView = UIView() 
        
        self.tableView.allowsMultipleSelection = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
        
        navigationItem.rightBarButtonItem = profileButton
        
        if Auth.auth().currentUser == nil {
            self.usernames = [] //if user is not logged in, no usernames are displayed
            tableView.reloadData()
        } else {
            loadData() //else, load usernames and follow button
            
            let bottomMargin = CGFloat(200) //Space between button and bottom of the screen
            let buttonSize = CGSize(width: 110, height: 50)

            let followButton = UIButton(frame: CGRect(
                    x: 0, y: 0, width: buttonSize.width, height: buttonSize.height
                ))

            followButton.center = CGPoint(x: tableView.bounds.size.width / 2,
                                    y: tableView.bounds.size.height - buttonSize.height / 2 - bottomMargin)
            followButton.backgroundColor = Themer.DarkTheme.tint
            followButton.setTitle(" Follow", for: .normal)
            followButton.setImage(UIImage(named:"follow"), for: .normal)
            followButton.addTarget(self, action: #selector(didSelectFollowButton), for: .touchUpInside)
            self.view.addSubview(followButton)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    // MARK: - Table View Data Source
    @objc
    func loadData() {
        
        let rootRef = Database.database().reference()
        let userQuery = rootRef.child("users")
        let followingQuery = rootRef.child("users").child(Auth.auth().currentUser!.uid).child("following").child("approved")
        let pendingQuery = rootRef.child("users").child(Auth.auth().currentUser!.uid).child("following").child("pending")
        
        followingQuery.observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let value = child.value as! String
                self.following.append(value)
            }
            print(self.following)
        }
        
        pendingQuery.observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let value = child.value as! String
                self.pending.append(value)
            }
            print(self.pending)
        }
        
        userQuery.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let value = child.value as? NSDictionary
                let username = value?["username"] as? String ?? ""
                //do not display current user's username
                if Auth.auth().currentUser!.uid != child.key {
                    //do not display people the current user is already following
                    if !self.following.contains(username){
                        self.usernames.append(username)
                    }
                }
                print(username)
            }
            self.tableView.reloadData()
            print(self.usernames)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        cell.textLabel?.text = self.usernames[indexPath.row]
        cell.textLabel?.textColor = Themer.DarkTheme.text;
        cell.backgroundColor = Themer.DarkTheme.background;
        
        //if the username is already in the current user's followPending, disable selection and display "Requested" label
        if self.pending.contains(self.usernames[indexPath.row]){
            cell.isUserInteractionEnabled = false
            let pendingButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width-110, y: 5, width: 100, height: 30))
            pendingButton.setTitle("Requested", for: .normal)
            pendingButton.backgroundColor = Themer.DarkTheme.placeholderText
            cell.addSubview(pendingButton)
        }
        
        //highlights cell(s) if tapped
        if cell.isSelected {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        
        return cell
    }
    
    @objc
    func didSelectFollowButton(){
        print("You followed someone")
        
        //saves the selected list of usernames to followPending
        for user in self.usersToFollow{
            let rootRef = Database.database().reference()
            let query = rootRef.child("users").child(Auth.auth().currentUser!.uid).child("following").child("pending").child(user)
            query.setValue(user){
                (error:Error?, ref:DatabaseReference) in
                if let error = error {
                  print("Data could not be saved: \(error).")
                } else {
                  print("Data saved successfully!")
                }
            }
            self.pending.append(user)
        }

        tableView.reloadData()
    }
    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        //add selected username to usersToFollow
        self.usersToFollow.append(self.usernames[indexPath.row])
        print(usersToFollow)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        //remove username from usersToFollow
        self.usersToFollow.removeAll(where: { $0 == self.usernames[indexPath.row] })
        print(usersToFollow)
    }
    
    @objc
    func displayAccountViewController(sender: UIBarButtonItem?) {
        let popoverRootVC = UINavigationController(rootViewController: AccountViewController())
        present(popoverRootVC, animated: true, completion: nil)
    }
    
}
