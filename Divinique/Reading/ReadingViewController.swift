//
//  ReadingViewController.swift
//  Divinique
//
//  Created by LinjunCai on 10/5/2024.
//

import UIKit

class ReadingViewController: UIViewController {
    
    @IBAction func threeCardsButton(_ sender: Any) {
        performSegue(withIdentifier: "tarotReadSegue", sender: (Any).self)
    }
    
    @IBAction func sixCardsButton(_ sender: Any) {
    }
    
    @IBAction func dailyTarotButton(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
