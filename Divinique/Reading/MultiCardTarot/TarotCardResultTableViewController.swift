//
//  TarotCardResultTableViewController.swift
//  Divinique
//
//  Created by LinjunCai on 16/5/2024.
//

import UIKit

class TarotCardResultTableViewController: UITableViewController{
    var cardNames: [String] = []; // Store card names

    func displaySelectCards(_ cardNumbers: [Int]) {
        print(cardNumbers, "1")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(cardNames)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //connect the cell viewcontroller
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tarotCardResultCell", for: indexPath) as? TarotCardResultTableViewCell else {
            fatalError("The dequeued cell is not an instance of TarotCardResultTableViewCell.")
        }
        //display each cell with the card
        let cardName = cardNames[indexPath.row]
        cell.tarotCardLabel.text = "Card Name: \(cardName)"

        // Fetch details asynchronously and configure the cell
        fetchCardDetails(for: cardName) { name, image, reading in
            DispatchQueue.main.async {
                cell.tarotCardLabel.text = name ?? "Unknown"
                cell.tarotCardImage.image = image ?? UIImage(named: "default_image") // Provide a default image
                cell.tarotCardReading.text = reading ?? "No reading available"
            }
        }
        
        return cell
    }
    //Search the card wth the card name in the API
    func fetchCardDetails(for cardName: String, completion: @escaping (String?, UIImage?, String?) -> Void) {
        //API url
        let urlString = "https://tarotapi.dev/api/v1/cards/search?name_short=\(cardName)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil, nil, nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching card details: \(String(describing: error))")
                completion(nil, nil, nil)
                return
            }

            do {
                //asign data got
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let cards = json["cards"] as? [[String: Any]],
                   let firstCard = cards.first,
                   let name = firstCard["name"] as? String {
                    //Get image from assets where the name match
                    let image = UIImage(named: name.lowercased())
                    let reading = firstCard["desc"]
                    DispatchQueue.main.async {
                        completion(name, image, reading as? String)
                    }
                } else {
                    completion(nil, nil, nil)
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
                completion(nil, nil, nil)
            }
        }
        task.resume()
    }

}
