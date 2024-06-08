//
//  ReadingController.swift
//  Divinique
//
//  Created by LinjunCai on 23/5/2024.
//

import UIKit

class ReadingController: NSObject, ReadingProtocol {
    
    // Set to keep track of cards that have already been displayed
    var displayedCards: Set<String> = []
    
    // Function to format Date objects to a string in the format "yyyy-MM-dd"
    func dateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    // Asynchronous function to fetch a specified number of random tarot cards
    func fetchRandomCard(numOfCard: Int) async -> [TarotCard] {
        var tarotCards: [TarotCard] = []
        
        // Loop until the required number of cards is fetched
        while tarotCards.count < numOfCard {
            // Fetch a random card
            if let card = await fetchRandomCards() {
                // Check if the card is valid and not already displayed
                if isValidCard(card) && !displayedCards.contains(card.name) {
                    // Randomly determine the state of the card (upright or reversed)
                    let state = Int32.random(in: 0...1)
                    // Get the current date as a string
                    let today = dateFormatter(date: Date())
                    // Create a TarotCard object with the fetched details
                    let tarotCard = TarotCard(name: card.name, state: state, meaning: state == 1 ? card.meaningUp : card.meaningRev, desc: card.desc, date: today)
                    // Add the card to the list of fetched cards
                    tarotCards.append(tarotCard)
                    print(card.name)
                    // Add the card name to the set of displayed cards
                    displayedCards.insert(card.name)
                }
            }
        }
        
        // Return the list of fetched tarot cards
        return tarotCards
    }
    
    // Asynchronous function to fetch a random card from the API
    func fetchRandomCards() async -> (name: String, meaningUp: String, meaningRev: String, desc: String)? {
        print("Fetching a random card")
        // Validate the URL
        guard let url = URL(string: "https://tarotapi.dev/api/v1/cards/random?n=1") else {
            print("Invalid URL")
            return nil
        }
        
        do {
            // Fetch data from the URL
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Ensure the response is valid
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response")
                return nil
            }
            
            // Parse the JSON response
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let cards = json["cards"] as? [[String: Any]],
               let firstCard = cards.first,
               let name = firstCard["name"] as? String,
               let meaningUp = firstCard["meaning_up"] as? String,
               let meaningRev = firstCard["meaning_rev"] as? String,
               let desc = firstCard["desc"] as? String {
                // Return the details of the first card
                return (name, meaningUp, meaningRev, desc)
            } else {
                return nil
            }
        } catch {
            // Handle errors during data fetching
            print("Error fetching tarot card: \(error)")
            return nil
        }
    }
    
    // Function to validate if the card has a corresponding image in the app's assets
    func isValidCard(_ card: (name: String, meaningUp: String, meaningRev: String, desc: String)) -> Bool {
        // Convert card name to lowercase to match image naming convention
        let imageName = card.name.lowercased()
        // Check if an image with the card name exists in the assets
        if UIImage(named: imageName) != nil {
            return true
        } else {
            return false
        }
    }
}
