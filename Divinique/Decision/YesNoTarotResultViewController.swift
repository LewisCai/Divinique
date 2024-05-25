//
//  YesNoTarotResultViewController.swift
//  Divinique
//
//  Created by LinjunCai on 25/5/2024.
//

import UIKit

class YesNoTarotResultViewController: UIViewController {
    
    @IBOutlet weak var tarotCardName: UILabel!
    
    @IBOutlet weak var cardImage: UIImageView!
    
    @IBOutlet weak var resultText: UILabel!
    
    var tarotCard: TarotCard?

    override func viewDidLoad() {
        super.viewDidLoad()
        tarotCardName.text = tarotCard?.name
        cardImage.image = UIImage(named: tarotCard?.name.lowercased() ?? "the fool")
        
        // Do any additional setup after loading the view.
    }
    
    

}
