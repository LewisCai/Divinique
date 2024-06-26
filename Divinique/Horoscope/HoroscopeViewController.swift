//
//  HoroscopeViewController.swift
//  Divinique
//
//  Created by LinjunCai on 2/5/2024.
//

import UIKit

class HoroscopeViewController: UIViewController {
    
    @IBOutlet weak var chineseZodiacBtn: UIButton!
    
    @IBOutlet weak var zodiacBtn: UIButton!
    
    @IBAction func chineseZodiacButton(_ sender: Any) {
        performSegue(withIdentifier: "chineseZodiacSegue", sender: UIButton())
    }
    
    
    @IBAction func zodiacButton(_ sender: Any) {
        performSegue(withIdentifier: "zodiacSegue", sender: UIButton())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the image view
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Background")
        
        // Set the content mode
        backgroundImage.contentMode = .scaleAspectFill  // This will cover the entire screen without distorting the aspect ratio
        
        // Add the image view to the view and send it to the back
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
        
        let image = UIImage(named: "chineseZodiac.png") // Make sure the image name is correct
        chineseZodiacBtn.setImage(image, for: .normal)
        chineseZodiacBtn.imageView?.contentMode = .scaleAspectFit
        
        // Attach actions for touch down and touch up inside
        chineseZodiacBtn.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        chineseZodiacBtn.addTarget(self, action: #selector(buttonUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        let image2 = UIImage(named: "zodiac.png")
        zodiacBtn.setImage(image2, for: .normal)
        
        //Add button interaction 
        zodiacBtn.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        zodiacBtn.addTarget(self, action: #selector(buttonUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
    }
    
    @objc func buttonDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            // Scale down the button to 90% of its size
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
    }

    @objc func buttonUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            // Scale back to original size
            sender.transform = CGAffineTransform.identity
        })
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
