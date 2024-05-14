//
//  DecisionViewController.swift
//  Divinique
//
//  Created by LinjunCai on 10/5/2024.
//

import UIKit

class DecisionViewController: UIViewController {
    
    @IBOutlet weak var magicOrbImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        magicOrbImage.image = UIImage(named: "magicOrbDark.png")
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        magicOrbImage.addGestureRecognizer(tapGesture)
    }
    
    @objc func imageTapped() {
        // Scale up the image
        UIView.animate(withDuration: 0.2, animations: {
            self.magicOrbImage.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { [weak self] _ in
            // Scale down with a bounce effect
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                self?.magicOrbImage.transform = CGAffineTransform.identity
            }) { _ in
                // After the scale down animation, change the image with a fade effect
                UIView.transition(with: self!.magicOrbImage, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self?.magicOrbImage.image = UIImage(named: "magicOrbBright.png")
                }) { _ in
                    // Perform segue after the image has finished transitioning
                    self?.performSegue(withIdentifier: "magicBallSegue", sender: self)
                }
            }
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
