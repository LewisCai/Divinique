//
//  TarotCardReadingViewController.swift
//  Divinique
//
//  Created by LinjunCai on 10/5/2024.
//

import UIKit
import QuartzCore

class TarotCardReadingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var resultVC: TarotCardResultTableViewController?
    var cardFullNames: [String] = []
    var cardNames: [String] = []  // Array to store selected card numbers
    var maxCard: Int = 10
    
    @IBOutlet weak var collectionTarotCards: UICollectionView!
    
    @IBAction func getReadingBtn(_ sender: Any) {
        if cardCount == maxCard {
            resultVC?.cardNames = cardNames
            print(cardNames, cardFullNames)
            performSegue(withIdentifier: "threeCardResultSegue", sender: (Any).self)
        } else {
            displayMessage(title: "Invalid Cards", message: "Need to select three cards")
        }
    }
    
    @IBAction func spinWheel(_ sender: Any) {
        //gives a card
    }
    
    @IBOutlet weak var spinWheelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWheelButton()
        setupCollectionView()
    }
    
    private func setupWheelButton() {
        let image = UIImage(named: "tarotWheel.png") // Ensure the image name is correct
        spinWheelBtn.setImage(image, for: .normal)
        spinWheelBtn.imageView?.contentMode = .scaleAspectFit
        spinWheelBtn.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        spinWheelBtn.addTarget(self, action: #selector(buttonUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    private func setupCollectionView() {
        print("Setting up collection view")
        collectionTarotCards.dataSource = self
        collectionTarotCards.delegate = self
    }
    
    @objc func buttonDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            // Scale down the button to 90% of its size
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }

    @objc func buttonUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            sender.transform = .identity
        }) { [weak self] _ in
            self?.spinWheel(sender)
            if let self = self, self.cardCount < self.maxCard {
                self.displayNextCard()
            } else {
                self?.displayMessage(title: "Max Cards Reached", message: "You have reached the maximum number of cards.")
            }
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
                   let name = firstCard["name"] as? String,
                   let nameShort = firstCard["name_short"] as? String {
                       DispatchQueue.main.async {
                           self.cardNames.append(nameShort)  // Append value_int to cardNumbers
                       }
                       completion(name)  // Return the name of the card
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
            guard let cardName = cardName else {
                print("Failed to load card image")
                return
            }
            
            print(cardName)
            
            DispatchQueue.main.async {
                if self?.cardCount ?? 0 < self?.maxCard ?? 0 {
                    self?.cardFullNames.append(cardName)
                    self?.collectionTarotCards.reloadData()
                    self?.cardCount += 1
                    print("Card added: \(cardName)")
                }
            }
        }
    }
    
    func displayMessage(title: String, message: String){
            let alertController = UIAlertController(title: title, message: message,
             preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,
             handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "threeCardResultSegue" {
            if let destinationVC = segue.destination as? TarotCardResultTableViewController {
                destinationVC.cardNames = self.cardNames
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Number of items: \(cardFullNames.count)")
        return cardFullNames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TarotCardCell", for: indexPath) as! TarotCardCell
        print("full names:", cardFullNames)
        let cardName = cardFullNames[indexPath.item].lowercased()
        cell.imageView.image = UIImage(named: cardName) ?? UIImage(named: "the fool") // Provide a default image if not found
        return cell
    }
}
