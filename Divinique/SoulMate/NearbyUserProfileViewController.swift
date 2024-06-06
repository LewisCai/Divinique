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
        let userId = annotation?.userId
        let currentUserId = (annotation?.currentUserId)!
        
        let db = Firestore.firestore()
        let currentUserDocRef = db.collection("users").document(currentUserId)
        
        db.collection("users").whereField("userId", isEqualTo: currentUserId).getDocuments { (snapshot, error) in
            guard let document = snapshot?.documents.first else {
                print("User document not found: \(String(describing: error))")
                return
            }
            
            // Update the friends array in the user's document
            document.reference.updateData([
                "friends": FieldValue.arrayUnion([userId!])
            ]) { error in
                if let error = error {
                    self.displayMessage(title: "Error", message: "Error adding friend: \(error.localizedDescription)")
                } else {
                    self.displayMessage(title: "Success", message: "Friend added successfully")
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

        // Do any additional setup after loading the view.
    }
    
    func displayMessage(title: String, message: String){
            let alertController = UIAlertController(title: title, message: message,
             preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,
             handler: nil))
            self.present(alertController, animated: true, completion: nil)
    }

}
