//
//  NearbyUserProfileViewController.swift
//  Divinique
//
//  Created by LinjunCai on 6/6/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class NearbyUserProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var starSignLabel: UILabel!
    @IBOutlet weak var userBioText: UITextView!
    
    @IBAction func addFriendBtn(_ sender: Any) {
        // add a friend
        guard let userId = annotation?.userId,
              let currentUserId = annotation?.currentUserId else {
            print("User ID or Current User ID is missing")
            return
        }
        
        let db = Firestore.firestore()
        
        // Update current user's friend list
        db.collection("users").whereField("userId", isEqualTo: currentUserId).getDocuments { (snapshot, error) in
            guard let currentUserDocument = snapshot?.documents.first else {
                print("Current user document not found: \(String(describing: error))")
                return
            }
            
            //update
            currentUserDocument.reference.updateData([
                "friends": FieldValue.arrayUnion([userId])
            ]) { error in
                if let error = error {
                    self.displayMessage(title: "Error", message: "Error adding friend: \(error.localizedDescription)")
                } else {
                    print("Friend added to current user's friend list")
                    
                    // Update the other user's friend list
                    db.collection("users").whereField("userId", isEqualTo: userId).getDocuments { (snapshot, error) in
                        guard let userDocument = snapshot?.documents.first else {
                            print("User document not found: \(String(describing: error))")
                            return
                        }
                        //update
                        userDocument.reference.updateData([
                            "friends": FieldValue.arrayUnion([currentUserId])
                        ]) { error in
                            if let error = error {
                                self.displayMessage(title: "Error", message: "Error adding friend: \(error.localizedDescription)")
                            } else {
                                self.displayMessage(title: "Success", message: "Friend added successfully to both users' friend lists")
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    var annotation: CustomAnnotation?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = annotation?.name
        self.birthdayLabel.text = annotation?.date
        self.starSignLabel.text = annotation?.star

        // Create the background image view
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Background3")
        
        // Set the content mode
        backgroundImage.contentMode = .scaleAspectFill  // This will cover the entire screen without distorting the aspect ratio
        
        // Add the image view to the view and send it to the back
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
    }
    
    func displayMessage(title: String, message: String){
            let alertController = UIAlertController(title: title, message: message,
             preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,
             handler: nil))
            self.present(alertController, animated: true, completion: nil)
    }

}
