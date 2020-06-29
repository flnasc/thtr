//
//  ManageFollowRequestsViewController.swift
//  feedback
//
//  Created by Nicole Nigro on 6/27/20.
//  Copyright © 2020 James Little. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ManageFollowRequestsViewController: UITableViewController {
    
    lazy var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(didSelectDoneButton))
    
    var followRequests: [String] = []
    
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Follow Requests"
        navigationItem.rightBarButtonItem = doneButton
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.tableFooterView = UIView()
        
        tableView.allowsSelection = false
        
        if Auth.auth().currentUser == nil {
            self.followRequests = [] //if user is not logged in, no follow requests displayed
            tableView.reloadData()
        } else {
            loadData() //else, load follow requests
        }

    }
    
    // MARK: - Table View Data Source
    @objc
    func loadData() {
        let rootRef = Database.database().reference()
        let query = rootRef.child("user_followers").child(Auth.auth().currentUser!.uid).child("followPending").child("usernames")
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                let value = snap.value
                print("key = \(key)  value = \(value!)")
                self.followRequests.append(value as! String)
                print(value as! String)
            }
            self.tableView.reloadData()
            print(self.followRequests)
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followRequests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "FollowRequestCell") as! FollowRequestCell?

        if cell == nil {
            //Create a new cell if `dequeueReusableCell(withIdentifier:)` returned nil
            cell = FollowRequestCell(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 44))
            
            //Add accept and decline button targets
            cell!.acceptButton.addTarget(self, action: #selector(didSelectAcceptButton), for: .touchUpInside)
            cell!.declineButton.addTarget(self, action: #selector(didSelectDeclineButton), for: .touchUpInside)
        }

        cell!.textLabel?.text = self.followRequests[indexPath.row]
        cell?.textLabel?.textColor = Themer.DarkTheme.text;
        cell!.backgroundColor = Themer.DarkTheme.background;
        
        //Keep the value of indexPath.row in the `tag` of the button
        cell!.acceptButton.tag = indexPath.row
        cell!.declineButton.tag = indexPath.row

        return cell!
    }
    
    @objc
    func didSelectDoneButton() {
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func didSelectAcceptButton(_ sender: UIButton) {
        let indexPathRow = sender.tag
        print("accepted")
        print("You accepted cell number \(indexPathRow).")
        
        //add that username to following
        let rootRef = Database.database().reference()
        let thisChild = rootRef.child("user_followers").child(Auth.auth().currentUser!.uid).child("following")
        let followingDict : [String : String] = ["username" : followRequests[indexPathRow]]
        thisChild.setValue(followingDict){
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            print("Data saved successfully!")
          }
        }
        
        //remove that username from followPending
        Database.database().reference().child("user_followers").child(Auth.auth().currentUser!.uid).child("followPending").child("usernames").child(String(indexPathRow)).removeValue()
        
        tableView.reloadData()
    }
    
    @objc func didSelectDeclineButton(_ sender: UIButton) {
        let indexPathRow = sender.tag
        print("declined")
        print("You declined cell number \(indexPathRow).")
        
        //remove that username from followPending
        Database.database().reference().child("user_followers").child(Auth.auth().currentUser!.uid).child("followPending").child("usernames").child(String(indexPathRow)).removeValue()
        
        tableView.reloadData()
    }

}
