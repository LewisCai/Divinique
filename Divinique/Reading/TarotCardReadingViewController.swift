//
//  TarotCardReadingViewController.swift
//  Divinique
//
//  Created by LinjunCai on 10/5/2024.
//

import UIKit
import QuartzCore

class TarotCardReadingViewController: UIViewController {
    
    @IBAction func spinWheel(_ sender: Any) {
        //gives a card
        
    }
    

    @IBOutlet weak var spinWheelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWheelButton()
    }
    
    private func setupWheelButton() {
        let image = UIImage(named: "tarotWheel.png") // Ensure the image name is correct
        spinWheelBtn.setImage(image, for: .normal)
        spinWheelBtn.imageView?.contentMode = .scaleAspectFit
        spinWheelBtn.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        spinWheelBtn.addTarget(self, action: #selector(buttonUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc func buttonDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            // Scale down the button to 90% of its size
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }

    @objc func buttonUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            // Scale back to original size
            sender.transform = CGAffineTransform.identity
        }) { _ in
            self.spinWheel(sender)
        }
    }

    private func spinWheel(_ sender: UIButton) {
        // Duration and rotations can be adjusted for desired effect
        let rotationDuration = 2.0 // Duration in seconds
        let rotations = 3.0 // Number of full rotations
        let fullRotation = CGFloat.pi * 2
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.fromValue = 0
        animation.toValue = fullRotation * rotations
        animation.duration = rotationDuration
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut) // Slow down towards the end
        sender.layer.add(animation, forKey: nil)
    }
}
