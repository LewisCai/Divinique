//
//  ChineseZodiacSignViewController.swift
//  Divinique
//
//  Created by LinjunCai on 3/5/2024.
//

import UIKit
import Foundation
import Firebase

class ChineseZodiacSignViewController: UIViewController {
    
    @IBOutlet weak var zodiacName: UILabel!
    
    @IBOutlet weak var zodiacImage: UIImageView!
    
    @IBOutlet weak var zodiacText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData { [weak self] result in
            switch result {
            case .success(let date):
                let sign = self?.chineseZodiacSign(from: date)
                self?.updateUI(with: sign)
            case .failure(let error):
                self?.displayMessage(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    func fetchUserData(completion: @escaping (Result<Date, Error>) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }

        let db = Firestore.firestore()
        let usersCollection = db.collection("users")
        let query = usersCollection.whereField("userId", isEqualTo: userID)

        query.getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = querySnapshot?.documents.first,
                      let dateString = document.data()["date"] as? String {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let date = dateFormatter.date(from: dateString) {
                    completion(.success(date))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Date format error"])))
                }
            } else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User data not found"])))
            }
        }
    }
    
    func chineseZodiacSign(from date: Date) -> String {
        let zodiacSigns = [
            "Dragon", "Snake",
            "Horse", "Goat", "Monkey", "Rooster", "Dog", "Pig","Rat", "Ox", "Tiger", "Rabbit"
        ]
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let index = (year - 4) % 12
        return zodiacSigns[index]
    }
    
    func updateUI(with sign: String?) {
        guard let sign = sign else {
            displayMessage(title: "Error", message: "Unable to determine zodiac sign")
            return
        }
        zodiacName.text = sign
        zodiacImage.image = UIImage(named: sign)
        zodiacText.text = getDesc(for: sign)
    }
    
    func getDesc(for sign: String) -> String {
        switch sign.lowercased() {
        case "rat":
            return "The Chinese zodiac rat holds a significant place in Chinese culture. The rat is considered clever, resourceful, and adaptable. In Chinese folklore, the rat is known for its intelligence and ability to overcome challenges. In Chinese tradition, it is believed that wearing accessories or clothing with rat imagery can bring luck and prosperity. People born in the Year of the Rat are believed to possess qualities such as wit, charm, and ambition. They are seen as quick thinkers and often excel in problem-solving."
        case "ox":
            return "The ox represents a strong work ethic and the ability to endure challenges. Chinese folklore often portrays the ox as an indispensable helper in agricultural labor. This association has led to the ox being regarded as a symbol of prosperity, productivity, and abundance."
        case "tiger":
            return "The Tiger is known as the king of all beasts in China. The zodiac sign Tiger is a symbol of strength, exorcising evils, and braveness. Many Chinese kids wear hats or shoes with a tiger image for good luck. People born in the year of the Tiger usually have a down-to-earth personality and down-to-earth work ethic. With great confidence and indomitable fortitude, they can be competent leaders."
        case "rabbit":
            return "The sign of Rabbit is a symbol of longevity, peace, and prosperity in Chinese culture. People born in a year of the Rabbit are called Rabbits and are believed to be vigilant, witty, quick-minded, and ingenious."
        case "dragon":
            return "In Chinese culture, the Dragon holds a significant place as an auspicious and extraordinary creature, unparalleled in talent and excellence. It symbolizes power, nobility, honor, luck, and success."
        case "snake":
            return "In Chinese zodiac, the snake is associated with wisdom, charm, elegance, and transformation. People born in the Year of the Snake are believed to be intuitive, strategic, and intelligent."
        case "horse":
            return "People born in the Year of the Horse are active and energetic, love being in a crowd, and can often be seen at sporting events, concerts, meetings, and parties. They have a straightforward and positive attitude towards life and are known for their communication skills."
        case "goat":
            return "The Goat, also known as the Sheep or Ram, is a symbol of gentleness, kindness, and peace in Chinese culture. People born in the year of the Goat are often considered artistic, compassionate, and nurturing. They are believed to have a calm and harmonious nature, fostering supportive environments for those around them. Although Goat people may look gentle on the surface, they usually possess a strong inner resilience, always insisting on their own opinions in their minds."
        case "monkey":
            return "It is a symbol of cleverness, versatility, and innovation. People born in the year of the Monkey are usually smart, quick-witted, and versatile. With a mischievous and playful nature, Monkeys are typically entertaining and can be great companions."
        case "rooster":
            return "In Chinese culture, the Rooster is often regarded as a symbol of perseverance, hard work, punctuality, timekeeping, and being alert. People born in the year of Rooster are usually self-assured, confident, and ambitious. They display dedication and discipline towards their tasks, often striving for excellence in whatever they do."
        case "dog":
            return "In Chinese culture, the Dog is highly regarded for its protective nature, strong sense of responsibility, and willingness to go above and beyond for loved ones. The zodiac sign Dog is a symbol of loyalty, companionship, and faithfulness. People born in the Year of the Dog are often described as reliable, honest, and steadfast."
        case "pig":
            return "With a round and fat face, the Pig is the symbol of wealth, felicity, honesty, and practicality in Chinese zodiac culture. Many money pots (Chinese piggybanks) are made pig-shaped as people believe Pig invocation will bring good luck monetarily. People born in the year of the Pig are usually tolerant, understanding, calm, down-to-earth, and easy to get along with. These make them a delightful companion and a trustworthy friend."
        default:
            return "Unknown zodiac sign."
        }
    }

    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
