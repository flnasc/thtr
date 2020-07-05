//
//  SignUpViewController.swift
//  feedback
//
//  Created by James Little on 9/17/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UITableViewController {

    let emailInput: UITextField = create {
        $0.attributedPlaceholder = NSAttributedString(string: "james@example.com", attributes: [.foregroundColor: Themer.DarkTheme.placeholderText])
        $0.textAlignment = .right
        $0.autocapitalizationType = .none
        $0.keyboardType = .emailAddress
        $0.autocorrectionType = .no
    }

    let emailLabel: THLabel = create {
        $0.text = "Email"
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let emailField: UIStackView = create {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let usernameInput: UITextField = create{
        $0.attributedPlaceholder = NSAttributedString(string: "nicolenigro", attributes: [.foregroundColor: Themer.DarkTheme.placeholderText])
        $0.textAlignment = .right
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }
    
    let usernameLabel: THLabel = create {
        $0.text = "Username"
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let usernameField: UIStackView = create {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let firstnameInput: UITextField = create{
        $0.attributedPlaceholder = NSAttributedString(string: "Nicole", attributes: [.foregroundColor: Themer.DarkTheme.placeholderText])
        $0.textAlignment = .right
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }
    
    let firstnameLabel: THLabel = create {
        $0.text = "First Name"
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let firstnameField: UIStackView = create {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let lastnameInput: UITextField = create{
        $0.attributedPlaceholder = NSAttributedString(string: "Nigro", attributes: [.foregroundColor: Themer.DarkTheme.placeholderText])
        $0.textAlignment = .right
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }
    
    let lastnameLabel: THLabel = create {
        $0.text = "Last Name"
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let lastnameField: UIStackView = create {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let ageInput: UITextField = create{
        $0.attributedPlaceholder = NSAttributedString(string: "20", attributes: [.foregroundColor: Themer.DarkTheme.placeholderText])
        $0.textAlignment = .right
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }
    
    let ageLabel: THLabel = create {
        $0.text = "Age"
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let ageField: UIStackView = create {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let phonenumberInput: UITextField = create{
        $0.attributedPlaceholder = NSAttributedString(string: "123-456-7890", attributes: [.foregroundColor: Themer.DarkTheme.placeholderText])
        $0.textAlignment = .right
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }
    
    let phonenumberLabel: THLabel = create {
        $0.text = "Phone Number"
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let phonenumberField: UIStackView = create {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let cityInput: UITextField = create{
        $0.attributedPlaceholder = NSAttributedString(string: "New York City", attributes: [.foregroundColor: Themer.DarkTheme.placeholderText])
        $0.textAlignment = .right
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }
    
    let cityLabel: THLabel = create {
        $0.text = "Home City/Town"
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let cityField: UIStackView = create {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let passwordInput: UITextField = create {
        $0.attributedPlaceholder = NSAttributedString(string: "••••••••", attributes: [.foregroundColor: Themer.DarkTheme.placeholderText])
        $0.textAlignment = .right
        $0.isSecureTextEntry = true
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }
    
    let passwordLabel: THLabel = create {
        $0.text = "Password"
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let passwordField: UIStackView = create {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let passwordConfirmInput: UITextField = create {
        $0.attributedPlaceholder = NSAttributedString(string: "••••••••", attributes: [.foregroundColor: Themer.DarkTheme.placeholderText])
        $0.textAlignment = .right
        $0.isSecureTextEntry = true
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }

    let passwordConfirmLabel: THLabel = create {
        $0.text = "Confirm Password"
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let passwordConfirmField: UIStackView = create {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let confirmButton: UIButton = create {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.titleLabel?.textColor = Themer.DarkTheme.tint
    }

    let confirmButtonContainer: UIStackView = create {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let cellReuseId = "reuseIdentifier"

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.addArrangedSubview(emailLabel)
        emailField.addArrangedSubview(emailInput)
        
        usernameField.addArrangedSubview(usernameLabel)
        usernameField.addArrangedSubview(usernameInput)
        
        firstnameField.addArrangedSubview(firstnameLabel)
        firstnameField.addArrangedSubview(firstnameInput)
        
        lastnameField.addArrangedSubview(lastnameLabel)
        lastnameField.addArrangedSubview(lastnameInput)
        
        ageField.addArrangedSubview(ageLabel)
        ageField.addArrangedSubview(ageInput)
        
        phonenumberField.addArrangedSubview(phonenumberLabel)
        phonenumberField.addArrangedSubview(phonenumberInput)
        
        cityField.addArrangedSubview(cityLabel)
        cityField.addArrangedSubview(cityInput)

        passwordField.addArrangedSubview(passwordLabel)
        passwordField.addArrangedSubview(passwordInput)

        passwordConfirmField.addArrangedSubview(passwordConfirmLabel)
        passwordConfirmField.addArrangedSubview(passwordConfirmInput)

        confirmButtonContainer.addArrangedSubview(confirmButton)
       
        confirmButton.setTitle("Sign Up", for: .normal)
        confirmButton.setTitleColor(Themer.DarkTheme.tint, for: .normal)
        confirmButton.addTarget(self, action: #selector(submitForm), for: .touchUpInside)

        navigationItem.title = "Sign Up"

        tableView.register(THTableViewCell.self, forCellReuseIdentifier: cellReuseId)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailInput.becomeFirstResponder()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)

        var subview: UIStackView?

        switch indexPath.row {
        case 0:
            subview = emailField
        case 1:
            subview = usernameField
        case 2:
            subview = firstnameField
        case 3:
            subview = lastnameField
        case 4:
            subview = ageField
        case 5:
            subview = phonenumberField
        case 6:
            subview = cityField
        case 7:
            subview = passwordField
        case 8:
            subview = passwordConfirmField
        case 9:
            subview = confirmButtonContainer
        default:
            fatalError("That's not how math works")
        }

        if let subview = subview {
            cell.contentView.addSubview(subview)

            NSLayoutConstraint.activate([
                subview.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
                subview.widthAnchor.constraint(equalTo: cell.widthAnchor, constant: -32),
                subview.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 16)
                ])
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }

    @objc
    func submitForm() {
        guard let email = emailInput.text,
            let username = usernameInput.text,
            let firstname = firstnameInput.text,
            let lastname = lastnameInput.text,
            let age = ageInput.text,
            let city = cityInput.text,
            let phonenumber = phonenumberInput.text,
            let password = passwordInput.text,
            let passwordConf = passwordConfirmInput.text else {
                return
        }

        guard password == passwordConf else {
            let alert = UIAlertController(title: "Passwords must match.", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.passwordInput.text = ""
                self.passwordConfirmInput.text = ""
                self.passwordInput.becomeFirstResponder()
            })
            self.present(alert, animated: true, completion: nil)
            return
        }

        Auth.auth().createUser(withEmail: email, username: username, firstname: firstname, lastname: lastname, age: age, city: city, phonenumber: phonenumber, password: password) { (authResult, error) in
            guard error == nil else {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }

            guard let user = authResult?.user else {
                let alert = UIAlertController(title: "Error", message: "User could not be created.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Bummer.", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            //save user's information to users branch of database
            let rootRef = Database.database().reference()
            let usersRef = rootRef.child("users")
            let thisChild = usersRef.child(Auth.auth().currentUser!.uid)
            let userDict : [String: String] = ["email": email, "username": username, "firstname": firstname, "lastname": lastname, "age": age, "city": city, "phonenumber": phonenumber]
            thisChild.setValue(userDict){
              (error:Error?, ref:DatabaseReference) in
              if let error = error {
                print("Data could not be saved: \(error).")
              } else {
                print("Data saved successfully!")
              }
            }
            
            NotificationCenter.default.post(
                Notification(name: Notification.Name(rawValue: "UserSetNotification"),
                             object: user, userInfo: nil))

            self.navigationController?.popViewController(animated: true)
        }
    }
}
