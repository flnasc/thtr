//
//  FollowRequestCell.swift
//  feedback
//
//  Created by Nicole Nigro on 6/28/20.
//  Copyright © 2020 James Little. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FollowRequestCell: UITableViewCell {

    weak var acceptButton: UIButton!
    weak var declineButton: UIButton!
           
    
    init(frame: CGRect) {
        //let acceptButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width-160, y: 0, width: 80, height: 40))
        //let declineButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width-80, y: 0, width: 80, height: 40))
        
        let acceptButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width-110, y: 0, width: 50, height: 50))
        let declineButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width-60, y: 0, width: 50, height: 50))
        
        self.acceptButton = acceptButton
        self.declineButton = declineButton
        
        super.init(style: .default, reuseIdentifier: "FollowRequestCell")
        self.frame = frame

        addSubview(acceptButton)
        //acceptButton.setTitle("Accept", for: .normal)
        acceptButton.setImage(UIImage(named:"check"), for: .normal)
        acceptButton.setTitleColor(UIColor.green, for: UIControl.State.normal)
        
        addSubview(declineButton)
        //declineButton.setTitle("Decline", for: .normal)
        declineButton.setImage(UIImage(named:"cross"), for: .normal)
        declineButton.setTitleColor(UIColor.red, for: UIControl.State.normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
