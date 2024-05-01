//
//  NewUserPageViewController.swift
//  Divinique
//
//  Created by LinjunCai on 1/5/2024.
//

import UIKit

class NewUserPageViewController: UIViewController {

    
    @IBOutlet weak var nameTextField: UITextField!
    

    @IBOutlet weak var datePicker: UIDatePicker!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = false
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
