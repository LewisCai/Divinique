//
//  LoginPageViewController.swift
//  Divinique
//
//  Created by LinjunCai on 1/5/2024.
//

import UIKit
import Firebase

class LoginPageViewController: UIViewController {
    
    @IBOutlet weak var UsernameEmailTextField: UITextField!
    
    
    @IBOutlet weak var PasswordTextField: UITextField!
    

    @IBAction func LoginButton(_ sender: Any) {
        guard let email = UsernameEmailTextField.text, let password = PasswordTextField.text else { return }
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    return
                }
                // Navigate to the main part of your app here
                self?.performSegue(withIdentifier: "showMainApp", sender: self)
            }
    }
    
    
    @IBAction func SignUpButton(_ sender: Any) {
        self.performSegue(withIdentifier: "showSignUpPage", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
