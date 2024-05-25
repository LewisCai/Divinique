//
//  ReadingController.swift
//  Divinique
//
//  Created by LinjunCai on 23/5/2024.
//

import UIKit

class ReadingController: NSObject, ReadingProtocol {
    
    var displayedCards: Set<String> = []
    
    func dateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    func fetchRandomCard(numOfCard: Int) async -> [TarotCard] {
        var tarotCards: [TarotCard] = []
        
        while tarotCards.count < numOfCard {
            if let card = await fetchRandomCards() {
                if isValidCard(card) && !displayedCards.contains(card.name) {
                    let state = Int32.random(in: 0...1)
                    let today = dateFormatter(date: Date())
                    let tarotCard = TarotCard(name: card.name, state: state, meaning: state == 1 ? card.meaningUp : card.meaningRev, desc: card.desc, date: today)
                    tarotCards.append(tarotCard)
                    displayedCards.insert(card.name)
                }
            }
        }
        
        return tarotCards
    }
    
    func fetchRandomCards() async -> (name: String, meaningUp: String, meaningRev: String, desc: String)? {
        print("Fetching a random card")
        guard let url = URL(string: "https://tarotapi.dev/api/v1/cards/random?n=1") else {
            print("Invalid URL")
            return nil
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response")
                return nil
            }
            
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let cards = json["cards"] as? [[String: Any]],
               let firstCard = cards.first,
               let name = firstCard["name"] as? String,
               let meaningUp = firstCard["meaning_up"] as? String,
               let meaningRev = firstCard["meaning_rev"] as? String,
               let desc = firstCard["desc"] as? String {
                return (name, meaningUp, meaningRev, desc)
            } else {
                return nil
            }
        } catch {
            print("Error fetching tarot card: \(error)")
            return nil
        }
    }
    
    func isValidCard(_ card: (name: String, meaningUp: String, meaningRev: String, desc: String)) -> Bool {
        // Check if the card image exists in the app's assets
        let imageName = card.name.lowercased()
        if UIImage(named: imageName) != nil {
            return true
        } else {
            return false
        }
    }
}
