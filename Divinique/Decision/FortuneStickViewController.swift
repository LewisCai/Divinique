//
//  FortuneStickViewController.swift
//  Divinique
//
//  Created by LinjunCai on 17/5/2024.
//

import UIKit

class FortuneStickViewController: UIViewController {
    
    @IBOutlet weak var fortuneStick: UIImageView!
    
    @IBOutlet weak var stickDesc: UITextView!
    
    //result for the sticks 
    let fortuneSticks = [
        (imageName: "FortuneStick", description: "上上签: Great fortune"),
        (imageName: "FortuneStick", description: "上签: Good fortune"),
        (imageName: "FortuneStick", description: "中签: Average fortune"),
        (imageName: "FortuneStick", description: "下签: Bad fortune"),
        (imageName: "FortuneStick", description: "下下签: Very bad fortune")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Randomly select a fortune stick
        let selectedStick = fortuneSticks.randomElement()!
        
        // Display the selected fortune stick
        fortuneStick.image = UIImage(named: selectedStick.imageName)
        stickDesc.text = selectedStick.description
    }

}
