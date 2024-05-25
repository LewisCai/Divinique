//
//  ReadingController.swift
//  Divinique
//
//  Created by LinjunCai on 23/5/2024.
//

import UIKit

class ReadingController: NSObject, ReadingProtocol{
    func dateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        // Set the desired date format for year, month, and day
        formatter.dateFormat = "yyyy-MM-dd"
        // Convert the date to a string
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    func fetchRandomCard(numOfCard: Int) async -> [TarotCard] {
        var tarotCards: [TarotCard] = []

        for _ in 0..<numOfCard {
            if let card = await fetchRandomCards() {
                let state = Int32.random(in: 0...1)
                let today = dateFormatter(date: Date())
                let tarotCard = TarotCard(name: card.name, state: state, meaning: state == 1 ? card.meaningUp : card.meaningRev, desc: card.desc, date: today)
                tarotCards.append(tarotCard)
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
}
