//
//  DecisionViewController.swift
//  Divinique
//
//  Created by LinjunCai on 10/5/2024.
//

import UIKit

class DecisionViewController: UIViewController {
    
    @IBOutlet weak var magicBallButton: UIButton!
    
    @IBAction func magicBallAction(_ sender: Any) {
        performSegue(withIdentifier: "magicBallSegue", sender: (Any).self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let image = UIImage(named: "magicOrb.png") // Make sure the image name is correct
        magicBallButton.setImage(image, for: .normal)
        magicBallButton.imageView?.contentMode = .scaleAspectFit
        
        // Attach actions for touch down and touch up inside
        magicBallButton.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        magicBallButton.addTarget(self, action: #selector(buttonUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
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
