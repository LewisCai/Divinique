//
//  TarotCardReadingViewController.swift
//  Divinique
//
//  Created by LinjunCai on 10/5/2024.
//

import UIKit
import QuartzCore

class TarotCardReadingViewController: UIViewController {
    
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var image3: UIImageView!
    
    @IBAction func getReadingBtn(_ sender: Any) {
        if cardCount == 3 {
            // Proceed to show reading
            print("Showing reading for selected cards")
        } else {
            print("Please select all cards first")
        }
    }
    
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
            sender.transform = CGAffineTransform.identity
        }) { [weak self] _ in
            self?.spinWheel(sender)
            self?.displayNextCard()  // Call after spinning for better UX
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
    
    func fetchRandomCard(completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://tarotapi.dev/api/v1/cards/random?n=1") else {
            print("Invalid URL")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching tarot card: \(error)")
                completion(nil)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let data = data else {
                print("Invalid response")
                completion(nil)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let cards = json["cards"] as? [[String: Any]],
                   let firstCard = cards.first,
                   let name = firstCard["name"] as? String {
                    completion(name)
                } else {
                    completion(nil)
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
                completion(nil)
            }
        }

        task.resume()
    }
    
    private var cardCount = 0

    private func displayNextCard() {
        fetchRandomCard { [weak self] cardName in
            guard let cardName = cardName, let image = UIImage(named: "The Fool") else {
                print("Failed to load card image")
                return
            }
            
            DispatchQueue.main.async {
                switch self?.cardCount {
                case 0:
                    self?.image1.image = image
                case 1:
                    self?.image2.image = image
                case 2:
                    self?.image3.image = image
                default:
                    print("All card slots are full")
                    return
                }
                self?.cardCount += 1
                print(self?.cardCount)
            }
        }
    }
    
}
