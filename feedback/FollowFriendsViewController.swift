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
    
    lazy var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(didSelectDoneButton))
    
    var usernames: [String] = []
    var usersToFollow: [String] = []

    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Follow Friends"
        navigationItem.rightBarButtonItem = doneButton
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.tableFooterView = UIView() 
        
        self.tableView.allowsMultipleSelection = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
        
        if Auth.auth().currentUser == nil {
            self.usernames = [] //if user is not logged in, no usernames are displayed
            tableView.reloadData()
        } else {
            loadData() //else, load usernames and follow button
            
            let bottomMargin = CGFloat(100) //Space between button and bottom of the screen
            let buttonSize = CGSize(width: 100, height: 50)

            let followButton = UIButton(frame: CGRect(
                    x: 0, y: 0, width: buttonSize.width, height: buttonSize.height
                ))

            followButton.center = CGPoint(x: tableView.bounds.size.width / 2,
                                    y: tableView.bounds.size.height - buttonSize.height / 2 - bottomMargin)

            followButton.backgroundColor = Themer.DarkTheme.tint
            followButton.setTitle("Follow", for: .normal)
            followButton.addTarget(self, action: #selector(didSelectFollowButton), for: .touchUpInside)
            self.view.addSubview(followButton)
        }
    }
    
    // MARK: - Table View Data Source
    @objc
    func loadData() {
        
        let rootRef = Database.database().reference()
        let query = rootRef.child("users").queryOrdered(byChild: "username")
        query.observeSingleEvent(of: .value) {
            (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let value = child.value as? NSDictionary
                let username = value?["username"] as? String ?? ""
                self.usernames.append(username)
                print(username)
            }
            self.tableView.reloadData()
            print(self.usernames)
        }
        //do not display current user (if UID of current user matches up to a parent branch, don't add that username)
        //if snapshot.description != Auth.auth().currentUser?.uid {
        //do not display users who are currently requested
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        cell.textLabel?.text = self.usernames[indexPath.row]
        cell.textLabel?.textColor = Themer.DarkTheme.text;
        cell.backgroundColor = Themer.DarkTheme.background;
        
        //highlights cell(s) if tapped
        if cell.isSelected {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        
        return cell
    }
   
    @objc
    func didSelectDoneButton() {
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc
    func didSelectFollowButton(){
        print("You followed someone")
        
        //saves the selected list of usernames to user_followers branch of database, storing them in the current user's followPending branch
        let rootRef = Database.database().reference()
        let userFollowersRef = rootRef.child("user_followers")
        let thisChild = userFollowersRef.child(Auth.auth().currentUser!.uid).child("followPending")
        let followerDict : [String : [String]] = ["usernames" : self.usersToFollow]
        thisChild.setValue(followerDict){
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            print("Data saved successfully!")
          }
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
    
}
