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
        
        let sign = astrologicalSign(from: date)
        
        // Format the date as needed
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: date)
        
        // Add user data to Firestore
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        db.collection("users").addDocument(data: [
            "name": name,
            "date": dateString,
            "userId": userID,
            "sign": sign,
            "latitude": "",
            "longitude": "",
            "friends": []
        ]) { error in
            if let error = error {
                self.displayMessage(title: "Error", message: "Something went wrong with database, try again later")
            } else {
                print("Document added successfully")
            }
        }
        
        performSegue(withIdentifier: "newUserToMain", sender: Self.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Hide naviagtion bar
        self.navigationItem.hidesBackButton = true
    }
    
    func displayMessage(title: String, message: String){
            let alertController = UIAlertController(title: title, message: message,
             preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,
             handler: nil))
            self.present(alertController, animated: true, completion: nil)
    }
    
    //This function is used to give the star sign based on ur birthday
    func astrologicalSign(from date: Date) -> String {
        let zodiacSigns = [
            "capricorn", "aquarius", "pisces", "aries", "taurus", "gemini",
            "cancer", "leo", "virgo", "libra", "scorpio", "sagittarius"
        ]
        
        let cutoffDates = [
            (month: 1, day: 20), (month: 2, day: 19), (month: 3, day: 21),
            (month: 4, day: 20), (month: 5, day: 21), (month: 6, day: 21),
            (month: 7, day: 23), (month: 8, day: 23), (month: 9, day: 23),
            (month: 10, day: 23), (month: 11, day: 22), (month: 12, day: 22)
        ]
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day], from: date)
        
        let month = components.month!
        let day = components.day!
        
        var index = month - 1
        //if user born before this day at this month then its the same index of star sign in zodiacSigns
        if day < cutoffDates[index].day {
            index = index == 0 ? 11 : index - 1
        }
        
        return zodiacSigns[index]
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
