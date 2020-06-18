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
 [] U. selects one or more friends
 [] U. selects "Follow"

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
    
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Follow Friends"
        navigationItem.rightBarButtonItem = doneButton
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.tableFooterView = UIView()
        
        if Auth.auth().currentUser == nil {
            self.usernames = [] //if user is not logged in, no usernames are displayed
            tableView.reloadData()
        } else {
            loadData() //else, load usernames
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
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        cell.textLabel?.text = self.usernames[indexPath.row]
        return cell
    }
       
    @objc
    func didSelectDoneButton() {
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}
