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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cardNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tarotCardResultCell", for: indexPath) as? TarotCardResultTableViewCell else {
            fatalError("The dequeued cell is not an instance of TarotCardResultTableViewCell.")
        }
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func fetchCardDetails(for cardName: String, completion: @escaping (String?, UIImage?, String?) -> Void) {
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
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let cards = json["cards"] as? [[String: Any]],
                   let firstCard = cards.first,
                   let name = firstCard["name"] as? String {
                    // Simulate fetching an image and reading
                    let image = UIImage(named: name.lowercased()) // You would replace this with actual image fetching logic
                    let reading = firstCard["desc"]// Simulate a reading
                    DispatchQueue.main.async {
                        completion(name, image, reading as! String)
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
