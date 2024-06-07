//
//  ProfileViewController.swift
//  Divinique
//
//  Created by LinjunCai on 7/6/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func profileChangeBtn(_ sender: Any) {
        //ignored
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func changeNameBtn(_ sender: Any) {
        let alertController = UIAlertController(title: "Change Name", message: "Enter your new name", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "New Name"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let nameField = alertController.textFields?.first, let newName = nameField.text, !newName.isEmpty {
                self.updateUserName(newName)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var birthdayLabel: UILabel!
    
    @IBAction func changeBirthdayBtn(_ sender: Any) {
        let alertController = UIAlertController(title: "Change Birthday", message: "Enter your new birthday (dd/MM/yyyy)", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "dd/MM/yyyy"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let birthdayField = alertController.textFields?.first, let newBirthday = birthdayField.text, !newBirthday.isEmpty {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                if let date = formatter.date(from: newBirthday) {
                    let originalFormatter = DateFormatter()
                    originalFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let originalBirthdayString = originalFormatter.string(from: date)
                    self.updateUserBirthday(originalBirthdayString, displayFormat: newBirthday)
                } else {
                    self.showErrorAlert("Invalid Date", "Please enter the date in dd/MM/yyyy format.")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Make the profile image view circular
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        loadProfileData()
    }
    
    // MARK: - Load Profile Data
    func loadProfileData() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("users").whereField("userId", isEqualTo: currentUserId).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                return
            }
            
            guard let document = snapshot?.documents.first else {
                print("No matching documents.")
                return
            }
            
            let data = document.data()
            if let base64String = data["profileImageBase64"] as? String,
               let imageData = Data(base64Encoded: base64String),
               let image = UIImage(data: imageData) {
                self.profileImage.image = image
            }
            self.nameLabel.text = data["name"] as? String
            
            if let birthdayString = data["date"] as? String {
                let formattedBirthday = self.formatBirthdayString(birthdayString)
                self.birthdayLabel.text = formattedBirthday
            }
        }
    }
    
    func formatBirthdayString(_ birthdayString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = inputFormatter.date(from: birthdayString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd/MM/yyyy"
            return outputFormatter.string(from: date)
        } else {
            return birthdayString // Return original string if formatting fails
        }
    }
    
    func updateUserName(_ newName: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("users").whereField("userId", isEqualTo: currentUserId).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                return
            }
            
            guard let document = snapshot?.documents.first else {
                print("No matching documents.")
                return
            }
            
            document.reference.updateData([
                "name": newName
            ]) { error in
                if let error = error {
                    print("Error updating name: \(error.localizedDescription)")
                } else {
                    self.nameLabel.text = newName
                    print("Name successfully updated")
                }
            }
        }
    }
    
    func updateUserBirthday(_ newBirthday: String, displayFormat: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("users").whereField("userId", isEqualTo: currentUserId).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                return
            }
            
            guard let document = snapshot?.documents.first else {
                print("No matching documents.")
                return
            }
            
            document.reference.updateData([
                "date": newBirthday
            ]) { error in
                if let error = error {
                    print("Error updating birthday: \(error.localizedDescription)")
                } else {
                    self.birthdayLabel.text = displayFormat
                    print("Birthday successfully updated")
                }
            }
        }
    }
    
    func showErrorAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
