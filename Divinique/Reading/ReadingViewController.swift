//
//  ReadingViewController.swift
//  Divinique
//
//  Created by LinjunCai on 10/5/2024.
//

import UIKit

class ReadingViewController: UIViewController {
    var maxCard = 0
    
    @IBAction func threeCardsButton(_ sender: Any) {
        maxCard = 3
        performSegue(withIdentifier: "tarotReadSegue", sender: (Any).self)
    }
    
    @IBAction func sixCardsButton(_ sender: Any) {
        maxCard = 6
        performSegue(withIdentifier: "tarotReadSegue", sender: (Any).self)
    }
    
    @IBAction func dailyTarotButton(_ sender: Any) {
        performSegue(withIdentifier: "dailyTarotSegue", sender: (Any).self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create the image view
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Background2")
        
        // Set the content mode
        backgroundImage.contentMode = .scaleAspectFill  // This will cover the entire screen without distorting the aspect ratio
        
        // Add the image view to the view and send it to the back
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TarotCardReadingViewController {
            destinationVC.maxCard = self.maxCard
        }
    }

}
