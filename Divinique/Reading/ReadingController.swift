//
//  ReadingController.swift
//  Divinique
//
//  Created by LinjunCai on 23/5/2024.
//

import UIKit

class ReadingController: NSObject, ReadingProtocol{
    func fetchRandomCard(numOfCard: Int) -> [TarotCard] {
        var TarotCards: [TarotCard] = []

        for _ in 0..<numOfCard {
            fetchRandomCards { cardName, cardMeaningUp, cardMeaningRev, cardDesc in
                guard let cardName = cardName, let cardMeaningUp = cardMeaningUp, let cardMeaningRev = cardMeaningRev , let cardDesc = cardDesc else {
                    print("Failed to load card image")
                    return
                }
                let state = Int32.random(in: 0...1)
                
                print("generated this card:", cardName)
                
                var tarotCard = TarotCard(name: cardName, state: state, meaning: state == 1 ? cardMeaningUp : cardMeaningRev, desc: cardDesc, date: Date())
                
                TarotCards.append(tarotCard)
            }
        }
        
        return TarotCards
    }
    
    func fetchRandomCards(completion: @escaping (String?, String?, String?, String?) -> Void) {
        guard let url = URL(string: "https://tarotapi.dev/api/v1/cards/random?n=1") else {
            print("Invalid URL")
            completion(nil, nil, nil, nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching tarot card: \(error)")
                completion(nil, nil, nil, nil)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let data = data else {
                print("Invalid response")
                completion(nil, nil, nil, nil)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let cards = json["cards"] as? [[String: Any]],
                   let firstCard = cards.first,
                   let name = firstCard["name"] as? String,
                   //get a random number of 0 or 1
                   let tarotMeaningUp = firstCard["meaning_up"] as? String,
                   let tarotMeaningRev = firstCard["meaning_rev"] as? String,
                   let tarotDesc = firstCard["desc"] as? String 
                    {
                    completion(name, tarotMeaningUp, tarotMeaningRev, tarotDesc)
                    } else {
                    completion(nil, nil, nil, nil)
                   }
            } catch {
                print("JSON error: \(error.localizedDescription)")
                completion(nil, nil, nil, nil)
            }
        }

        task.resume()
    }
}
