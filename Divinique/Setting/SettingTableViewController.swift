//
//  SettingTableViewController.swift
//  Divinique
//
//  Created by LinjunCai on 7/6/2024.
//

import UIKit
import FirebaseAuth

class SettingTableViewController: UITableViewController {

    let settings = [
        ["Profile"],
        ["Notifications"],
        ["About", "Logout"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)
        cell.textLabel?.text = settings[indexPath.section][indexPath.row]
        cell.accessoryType = .disclosureIndicator // Show an arrow for navigation
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "General"
        case 1: return "Preferences"
        case 2: return "Others"
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle cell tap, navigate to different settings pages
        if indexPath.section == 0 && indexPath.row == 0 {
            performSegue(withIdentifier: "userProfileSegue", sender: self)
        } else if indexPath.section == 1 && indexPath.row == 0 {
            performSegue(withIdentifier: "notificationSegue", sender: self)
        } else if indexPath.section == 2 && indexPath.row == 0 {
            performSegue(withIdentifier: "aboutSegue", sender: self)
        } else if indexPath.section == 2 && indexPath.row == 1{
            //Log out
            logout()
        }
    }
    
    // Logout function
    func logout() {
        do {
            try Auth.auth().signOut()
            // Redirect to login screen
            if let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginPageViewController") {
                navigationController?.setViewControllers([loginViewController], animated: true)
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            let alertController = UIAlertController(title: "Error", message: "Failed to sign out. Please try again.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true, completion: nil)
        }
    }

}
