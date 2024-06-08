//
//  YesNoTarotViewController.swift
//  Divinique
//
//  Created by LinjunCai on 25/5/2024.
//

import UIKit

class YesNoTarotViewController: UIViewController {
    var readingController: ReadingProtocol?
    
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var image3: UIImageView!
    
    var newCardName:String = ""
    var newTarotCard: TarotCard?
    var hasTapped: Bool = false//this is used to make sure that the user only fliped one card
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        readingController = appDelegate?.readingController
        
        //set up image
        image1.image = UIImage(named: "tarotback")
        image2.image = UIImage(named: "tarotback")
        image3.image = UIImage(named: "tarotback")
        
        // Enable user interaction for the image views
        image1.isUserInteractionEnabled = true
        image2.isUserInteractionEnabled = true
        image3.isUserInteractionEnabled = true
        
        // Add tap gesture recognizers
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(image1Tapped))
        image1.addGestureRecognizer(tapGesture1)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(image2Tapped))
        image2.addGestureRecognizer(tapGesture2)
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(image3Tapped))
        image3.addGestureRecognizer(tapGesture3)

        // Get new card
        Task {
            let newCard = await readingController?.fetchRandomCard(numOfCard: 1).first
            newCardName = newCard?.name.lowercased() ?? "the fool"
            newTarotCard = newCard
        }
    }
    //check if user has already fliped a card, if not then flip it
    @objc func image1Tapped() {
        if !hasTapped {
            hasTapped = true
            flipCard(imageView: image1)
        }
    }
    
    @objc func image2Tapped() {
        if !hasTapped {
            hasTapped = true
            flipCard(imageView: image2)
        }
    }
    
    @objc func image3Tapped() {
        if !hasTapped {
            hasTapped = true
            flipCard(imageView: image3)
        }
    }
    
    //animation for fliping
    func flipCard(imageView: UIImageView) {
        //go to the result view 
        UIView.transition(with: imageView, duration: 0.6, options: .transitionFlipFromRight, animations: {
            imageView.image = UIImage(named: self.newCardName)
        }, completion: { _ in
            self.performSegue(withIdentifier: "yesNoTarotResultSegue", sender: self)
        })
        
        // Disable user interaction for all image views
        image1.isUserInteractionEnabled = false
        image2.isUserInteractionEnabled = false
        image3.isUserInteractionEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        if let destinationVC = segue.destination as? YesNoTarotResultViewController {
            destinationVC.tarotCard = newTarotCard
        }
    }
}
