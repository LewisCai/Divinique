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

        // Do any additional setup after loading the view.
    }
    
    private func signUpUser() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = passwordTextField2.text, !confirmPassword.isEmpty else {
            print("Please fill in all fields")
            return
        }
        
        guard password == confirmPassword else {
            print("Passwords do not match")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing up: \(error.localizedDescription)")
                return
            }
            // Here you can handle post-signup operations, like saving user profile data if needed
            self.handlePostSignUp()
        }
    }
    
    private func handlePostSignUp() {
        // Optionally perform segue or update UI
        print("User signed up successfully")
        performSegue(withIdentifier: "signupToHomeSegue", sender: self)
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
