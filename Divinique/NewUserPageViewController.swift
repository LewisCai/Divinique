//
//  NewUserPageViewController.swift
//  Divinique
//
//  Created by LinjunCai on 1/5/2024.
//

import UIKit
import Firebase


class NewUserPageViewController: UIViewController {

    
    @IBOutlet weak var nameTextField: UITextField!
    

    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBAction func doneButton(_ sender: Any) {
        
        guard let name = nameTextField.text, !name.isEmpty else {
            displayMessage(title: "Empty Name", message: "Please enter a name")
            return
        }
        
        let date = datePicker.date
        
        // Format the date as needed
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: date)
        
        // Add user data to Firestore
        let db = Firestore.firestore()
        db.collection("users").addDocument(data: [
            "name": name,
            "date": dateString
        ]) { error in
            if let error = error {
                self.displayMessage(title: "Error", message: "Something went wrong with database, try again later")
            } else {
                print("Document added successfully")
            }
        }
        
        performSegue(withIdentifier: "newUserToHome", sender: Self.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }
    
    func displayMessage(title: String, message: String){
            let alertController = UIAlertController(title: title, message: message,
             preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,
             handler: nil))
            self.present(alertController, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
