//
//  NewUserPageViewController.swift
//  Divinique
//
//  Created by LinjunCai on 1/5/2024.
//

import UIKit

class NewUserPageViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var birthdayTextField: UITextField!
    
    @IBOutlet weak var birthTimeTextField: UITextField!
    
    @IBOutlet weak var datePickerTextField: UITextField!
    
    let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        // Configure date picker mode
        datePicker.datePickerMode = .dateAndTime
        
        // Set minimum and maximum dates if needed
        // datePicker.minimumDate = Date()
        
        // Assign date picker as input view to the text field
        datePickerTextField.inputView = datePicker
        
        // Add a toolbar with "Done" button to dismiss the picker
        addToolBar()
    }
    
    func addToolBar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: false)
        
        datePickerTextField.inputAccessoryView = toolbar
    }

    @objc func doneButtonTapped() {
        datePickerTextField.resignFirstResponder()
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
