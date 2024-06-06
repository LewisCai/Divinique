//
//  LoginPageViewController.swift
//  Divinique
//
//  Created by LinjunCai on 1/5/2024.
//

import UIKit
import Firebase
import CoreLocation

class LoginPageViewController: UIViewController {
    
    @IBOutlet weak var UsernameEmailTextField: UITextField!
    
    
    @IBOutlet weak var PasswordTextField: UITextField!
    

    @IBAction func LoginButton(_ sender: Any) {
        guard let email = UsernameEmailTextField.text, !email.isEmpty else {
                displayMessage(title: "Login Error", message: "Please enter your email.")
                return
            }
            
        guard let password = PasswordTextField.text, !password.isEmpty else {
                displayMessage(title: "Login Error", message: "Please enter your password.")
                return
            }
        
        guard let email = UsernameEmailTextField.text, let password = PasswordTextField.text else { return }
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    self?.displayMessage(title: "Login Error", message: error.localizedDescription)
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
        navigationController?.navigationBar.titleTextAttributes = [
                .font: UIFont(name: "HelveticaNeue-Bold", size: 20)!,
                .foregroundColor: UIColor.white
            ]

        // Create the image view
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "LoginBackground")  
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
