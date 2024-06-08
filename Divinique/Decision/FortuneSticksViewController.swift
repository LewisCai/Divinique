//
//  FortuneSticksViewController.swift
//  Divinique
//
//  Created by LinjunCai on 16/5/2024.
//

import UIKit

class FortuneSticksViewController: UIViewController {

    @IBOutlet weak var fortuneBox: UIImageView!
    
    //count the shakes, shake 4 times to get a sticks
    private var shakeCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set image
        fortuneBox.image = UIImage(named: "FortuneBox")

    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.resignFirstResponder()
    }

    // Called when a motion (shake) begins
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("Shake began")
            shakeCounter += 1
        }
    }

    // Called when a motion (shake) ends
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("Shake ended")
        }
        //if user done shake and shaked more than 4 times 
        if shakeCounter >= 4 {
            performSegue(withIdentifier: "fortuneStickSegue", sender: self)
        }
    }

}
