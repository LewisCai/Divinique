//
//  SignUpPageViewController.swift
//  Divinique
//
//  Created by LinjunCai on 1/5/2024.
//

import UIKit
import Firebase

class SignUpPageViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordTextField2: UITextField!
    
    @IBAction func signUpButton(_ sender: Any) {
        signUpUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "LoginBackground")
        // Set the content mode
        backgroundImage.contentMode = .scaleAspectFill  // This will cover the entire screen without distorting the aspect ratio
        
        // Add the image view to the view and send it to the back
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)

    }
    
    private func signUpUser() {
        //Check for valid email
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = passwordTextField2.text, !confirmPassword.isEmpty else {
            displayMessage(title: "Empty Textfield", message: "Please fill email and password")
            return
        }
        
        //check for valid password
        guard password == confirmPassword else {
            displayMessage(title: "Password not match", message: "Please make sure you have entered the same password")
            return
        }
        
        //create user with firebase
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing up: \(error.localizedDescription)")
                self.displayMessage(title: "Error signing up", message: error.localizedDescription)
                return
            }
            // Here you can handle post-signup operations, like saving user profile data if needed
            self.handlePostSignUp()
        }
    }
    
    private func handlePostSignUp() {
        // Optionally perform segue or update UI
        print("User signed up successfully")
        performSegue(withIdentifier: "newUserPage", sender: self)
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
