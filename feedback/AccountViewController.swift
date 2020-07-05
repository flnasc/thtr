//
//  AccountViewController.swift
//  feedback
//
//  Created by James Little on 9/17/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit
import MessageUI
import Firebase
import FirebaseStorage

class AccountViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    enum CellType {
        case signUp
        case logIn
        case changePassword
        case signOut
        case changeProfilePicture
        case reportAProblem
        case privacyPolicy
        case versionInfo
    }

    private static let alwaysVisibleCells = [
        CellType.reportAProblem,
        CellType.privacyPolicy,
        CellType.versionInfo
    ]

    var loggedOutVisibleCells: [CellType] {
        return [
            CellType.logIn,
            CellType.signUp
        ] + AccountViewController.alwaysVisibleCells
    }

    var loggedInVisibleCells: [CellType] {
        return [
            CellType.changePassword,
            CellType.signOut,
            CellType.changeProfilePicture
            ] + AccountViewController.alwaysVisibleCells
    }

    var visibleCells: [CellType] = []

    let defaultNavigationTitle = "Account"

    let cellReuseId = "reuseIdentifier"

    lazy var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(didSelectDoneButton))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil{
            visibleCells = loggedInVisibleCells
        } else {
            visibleCells = loggedOutVisibleCells
        }

        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.title = defaultNavigationTitle

        tableView.register(THTableViewCell.self, forCellReuseIdentifier: cellReuseId)

        NotificationCenter.default.addObserver(self, selector: #selector(userWasSet),
                                               name: Notification.Name("UserSetNotification"), object: nil)

        userWasSet()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleCells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)

        let cellType = visibleCells[indexPath.row]

        switch cellType {
        case .changePassword:
            cell.textLabel?.text = "Change Password"
        case .logIn:
            cell.textLabel?.text = "Log In"
        case .signUp:
            cell.textLabel?.text = "Sign Up"
        case .signOut:
            cell.textLabel?.text = "Sign Out"
        case .privacyPolicy:
            cell.textLabel?.text = "Privacy Policy"
        case .reportAProblem:
            cell.textLabel?.text = "Report a Problem"
        case .changeProfilePicture:
            cell.textLabel?.text = "Change Profile Picture"
        case .versionInfo:
            let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
            let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
            cell.textLabel?.text = "Build Number: \(appVersionString) (\(buildNumber))"
            cell.textLabel?.textColor = Themer.DarkTheme.placeholderText
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
            cell.textLabel?.textAlignment = .center
            return cell // different here bc no disclosure indicator
        }

        cell.accessoryType = .disclosureIndicator

        return cell
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = visibleCells[indexPath.row]

        tableView.deselectRow(at: indexPath, animated: true)

        switch cellType {
        case .changePassword:
            guard let email = Auth.auth().currentUser?.email else {
                return
            }

            let successMessage = NSLocalizedString("You will get an email with a link that will let you change your password. You will also be signed out.", comment: "Change Password Success Message")
            let alert = UIAlertController(title: "Are you sure?", message: successMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                Auth.auth().sendPasswordReset(withEmail: email, completion: self.didSendPasswordReset)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)

            return
        case .logIn:
            navigationController?.pushViewController(LogInViewController(), animated: true)
        case .signUp:
            navigationController?.pushViewController(SignUpViewController(), animated: true)
        case .signOut:
            signOut()
        case .reportAProblem:
            if !MFMailComposeViewController.canSendMail() {
                let alert = UIAlertController(title: "You cannot send mail today.", message: "Bummer.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }

            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self

            // Configure the fields of the interface.
            composeVC.setToRecipients(["jlittle@bowdoin.edu"])
            composeVC.setSubject("Feedback about THTR")
            composeVC.setMessageBody("", isHTML: false)

            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        case .privacyPolicy:
            let privacyVC = PrivacyPolicyViewController()
            let popoverRootVC = UINavigationController(rootViewController: privacyVC)
            present(popoverRootVC, animated: true, completion: nil)
        case .changeProfilePicture:
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            present(myPickerController, animated: true, completion: nil)
        case .versionInfo:
            return
        }
    }

    @objc
    func didSelectDoneButton() {
        if Auth.auth().currentUser != nil{
            dismiss(animated: true, completion: nil)
        }
    }

    func didSendPasswordReset(_ error: Error?) {
        if error != nil {
            let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        signOut()
        return
    }

    @objc
    func userWasSet() {
        if let user = Auth.auth().currentUser {
            navigationItem.title = user.email
            self.visibleCells = loggedInVisibleCells
        } else {
            navigationItem.title = "Account"
            self.visibleCells = loggedOutVisibleCells
        }

        tableView.reloadData()
    }

    func signOut() {
        do { try Auth.auth().signOut() } catch {}
        userWasSet()
    }

}

extension AccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            print("about to save")
            saveImage(image)
            print("worked")
        } else {
            print("Something went wrong")
        }
        dismiss(animated: true, completion: nil)
    }
    
    func saveImage(_ image: UIImage) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("profilePic")
        
        let compression: CGFloat = 0.8
        guard let data = image.jpegData(compressionQuality: compression) else {
            return
        }
        print("Compression quality chosen: \(compression)")

        let fileKey = "\(Date().timeIntervalSince1970)".components(separatedBy: ".")[0]
        let filePath = "\(Auth.auth().currentUser!.uid)/\(fileKey)"

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"

        let uploadTask = imagesRef.child(filePath).putData(data, metadata: metadata)

        uploadTask.observe(.success) { snapshot in
            let alert = UIAlertController(title: "File upload completed", message: "Your new profile picture is set!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)

            /*let photoValue = GlobalReviewCoordinator.getCurrentReview()?.extras["photo"]
            var outputPhotoValue: [String: String] = [:]

            if let imagePath = photoValue as? String {
                let pathKey = imagePath.components(separatedBy: ".")[0]
                outputPhotoValue = [pathKey: imagePath]
            } else if let imagePathDict = photoValue as? [String: String] {
                outputPhotoValue = imagePathDict
            }

            outputPhotoValue[fileKey] = snapshot.metadata?.path
            GlobalReviewCoordinator.getCurrentReview()?.extras["photo"] = outputPhotoValue*/
        }

        uploadTask.observe(.failure) { snapshot in
            print("Failure")
            if let error = snapshot.error as NSError? {
                switch StorageErrorCode(rawValue: error.code)! {
                case .objectNotFound:
                    // File doesn't exist
                    break
                case .unauthorized:
                    // User doesn't have permission to access file
                    break
                case .cancelled:
                    // User canceled the upload
                    break
                    /* ... */
                case .unknown:
                    // Unknown error occurred, inspect the server response
                    break
                default:
                    // A separate error occurred. This is a good place to retry the upload.
                    break
                }
            }
        }
    }
}
