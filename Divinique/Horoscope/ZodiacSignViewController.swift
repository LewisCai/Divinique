//
//  ZodiacSignViewController.swift
//  Divinique
//
//  Created by LinjunCai on 3/5/2024.
//

import UIKit
import Firebase
import Foundation

class ZodiacSignViewController: UIViewController {
    
    @IBOutlet weak var signLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var horoscope: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the image view
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Background")
        
        // Set the content mode
        backgroundImage.contentMode = .scaleAspectFill  // This will cover the entire screen without distorting the aspect ratio
        
        // Add the image view to the view and send it to the back
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
        
        //Get horoscope from API and display it at view
        fetchUserHoroscope { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let horoscope):
                    self?.updateUI(with: horoscope)  // Properly passing the Horoscope object
                case .failure(let error):
                    print("Error fetching horoscope: \(error)")
                    // Optionally, update the UI to indicate an error has occurred
                    self?.signLabel.text = "Error"
                    self?.dateLabel.text = "N/A"
                    self?.horoscope.text = "Failed to load data."
                    self?.icon.image = UIImage(systemName: "exclamationmark.triangle")
                }
            }
        }
    }
    
    func updateUI(with horoscope: Horoscope) {
        //Asign text to the UI elements
        signLabel.text = horoscope.sign
        dateLabel.text = horoscope.date
        self.horoscope.text = horoscope.horoscope
        
        print(horoscope.horoscope)
        //get image with image url
        if let imageURL = URL(string: horoscope.icon) {
            URLSession.shared.dataTask(with: imageURL) { [weak self] data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self?.icon.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
    
    //Fetch horoscope in a completion, so that the program will wait for it
    func fetchUserHoroscope(completion: @escaping (Result<Horoscope, Error>) -> Void) {
        //Get current user id from firebase
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }
        
        let db = Firestore.firestore()
        let usersCollection = db.collection("users")
        let query = usersCollection.whereField("userId", isEqualTo: userID)

        //get the user document with userId
        query.getDocuments { [weak self] querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(.failure(error))
            } else if let document = querySnapshot?.documents.first, // Assuming there's only one document per user ID
                      let sign = document.data()["sign"] as? String {
                // Now call fetchHoroscope with the correct parameters i got
                let today = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.string(from: today)
                let lang = "en"
                self?.fetchHoroscope(for: sign, date: date, lang: lang, completion: completion)
            } else {
                completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "No user data available"])))
            }
        }
    }
        
    func fetchHoroscope(for sign: String, date: String, lang: String, completion: @escaping (Result<Horoscope, Error>) -> Void) {
        //set up api link
        let baseURLString = "https://newastro.vercel.app/\(sign)?date=\(date)&lang=\(lang)"

        //check if its a valid url
        guard let url = URL(string: baseURLString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        //get response from url and decode it 
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                let horoscope = try decoder.decode(Horoscope.self, from: data)
                completion(.success(horoscope))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
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

