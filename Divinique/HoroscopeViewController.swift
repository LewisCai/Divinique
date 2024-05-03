//
//  HoroscopeViewController.swift
//  Divinique
//
//  Created by LinjunCai on 2/5/2024.
//

import UIKit

class HoroscopeViewController: UIViewController {
    
    @IBOutlet weak var chineseZodiacBtn: UIButton!
    
    @IBAction func chineseZodiacButton(_ sender: Any) {
    }
    
    
    @IBAction func zodiacButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "chineseZodiac.png") // Make sure the image name is correct
        chineseZodiacBtn.setImage(image, for: .normal)
        chineseZodiacBtn.imageView?.contentMode = .scaleAspectFit
        
        // Attach actions for touch down and touch up inside
        chineseZodiacBtn.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        chineseZodiacBtn.addTarget(self, action: #selector(buttonUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
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
