//
//  FortuneCookieOpenedViewController.swift
//  Divinique
//
//  Created by LinjunCai on 25/5/2024.
//

import UIKit

class FortuneCookieOpenedViewController: UIViewController {
    
    @IBOutlet weak var cookieOpenedImage: UIImageView!
    
    @IBOutlet weak var cookieQuoteText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set image
        cookieOpenedImage.image = UIImage(named: "FortuneCookie1")
        //call api to get a quote
        getRandomQuote { quote in
            DispatchQueue.main.async {
                self.cookieQuoteText.text = quote
            }
        }
    }

    //API call
    func getRandomQuote(completion: @escaping (String) -> Void) {
        let urlString = "https://api.quotable.io/quotes/random"
        guard let url = URL(string: urlString) else {
            completion("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion("Failed to retrieve quote: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                completion("No data received")
                return
            }
            
            do {
                //decode the call result 
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]],
                   let firstQuote = json.first,
                   let content = firstQuote["content"] as? String,
                   let author = firstQuote["author"] as? String {
                    let quote = "\"\(content)\" - \(author)"
                    completion(quote)
                } else {
                    completion("Failed to parse quote")
                }
            } catch {
                completion("Failed to parse JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }

}
