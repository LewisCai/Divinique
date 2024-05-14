//
//  MagicBallViewController.swift
//  Divinique
//
//  Created by LinjunCai on 10/5/2024.
//

import UIKit

class MagicBallViewController: UIViewController {
    
    @IBOutlet weak var magicOrbImage: UIImageView!
    
    @IBOutlet weak var answerText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        magicOrbImage.image = UIImage(named: "magicOrbDark") // Replace 'initialImage' with your initial image name
        magicOrbImage.isUserInteractionEnabled = true // Important: UIImageView by default is not interactive
        addLongPressGesture()

        // Do any additional setup after loading the view.
    }
    
    func addLongPressGesture() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressRecognizer.minimumPressDuration = 2.0  // how long the press should be
        magicOrbImage.addGestureRecognizer(longPressRecognizer)
    }

    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            magicOrbImage.image = UIImage(named: "magicOrbBright")
            answerText.text = randomResponse()
        }
    }
    
    func randomResponse() -> String {
        let choice = Int.random(in: 1...20)  // Randomly generates a number from 1 to 20

        switch choice {
        case 1:
            return "It is certain."
        case 2:
            return "It is decidedly so."
        case 3:
            return "Without a doubt."
        case 4:
            return "Yes - definitely."
        case 5:
            return "You may rely on it."
        case 6:
            return "As I see it, yes."
        case 7:
            return "Most likely."
        case 8:
            return "Outlook good."
        case 9:
            return "Yes."
        case 10:
            return "Signs point to yes."
        case 11:
            return "Reply hazy, try again."
        case 12:
            return "Ask again later."
        case 13:
            return "Better not tell you now."
        case 14:
            return "Cannot predict now."
        case 15:
            return "Concentrate and ask again."
        case 16:
            return "Don't count on it."
        case 17:
            return "My reply is no."
        case 18:
            return "My sources say no."
        case 19:
            return "Outlook not so good."
        case 20:
            return "Very doubtful."
        default:
            return "Unexpected error."
        }
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
