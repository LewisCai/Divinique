//
//  FortuneCookiesViewController.swift
//  Divinique
//
//  Created by LinjunCai on 17/5/2024.
//

import UIKit

class FortuneCookiesViewController: UIViewController {

    
    @IBOutlet weak var fortuneCookieImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fortuneCookieImage.image = UIImage(named: "FortuneCookie")
        // Create a swipe gesture recognizer
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeGesture.direction = .down // swipe down
        fortuneCookieImage.addGestureRecognizer(swipeGesture)
        fortuneCookieImage.isUserInteractionEnabled = true // Enable user interaction
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        //swipe trigger segue 
        performSegue(withIdentifier: "cookieOpenedSegue", sender: self)
    }
}
