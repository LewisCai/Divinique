//
//  DailyTarotViewController.swift
//  Divinique
//
//  Created by LinjunCai on 23/5/2024.
//

import UIKit
import CoreData

class DailyTarotViewController: UIViewController {
    weak var databaseController: DatabaseProtocol?
    weak var coredataController: CoreDataController?
    
    
    @IBOutlet weak var tarotNameLabel: UILabel!
    
    @IBOutlet weak var tarotImage: UIImageView!
    
    @IBOutlet weak var tarotStateLabel: UILabel!
    
    @IBOutlet weak var tarotMeaningText: UITextView!
    
    @IBOutlet weak var tarotDescText: UITextView!
        
    @IBAction func segControl(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        displayTodayTarot()
        scheduleDailyNotification()
    }
    
    // Display today's tarot card by searching for a card in the database that has today's date
    func displayTodayTarot() {
        let today = Date()
        let tarotCards = coredataController?.fetchAllTarotCards() ?? []

        if let storedTarot = tarotCards.first(where: { $0.date == today }) {
            updateUI(with: storedTarot)
        } else {
            print("No tarot card found for today's date, generating a new one.")
            let newTarot = generateTarotForToday()
            databaseController?.addTarotCardData(tarotName: newTarot.tarotName ?? "Unknown", tarotState: newTarot.tarotState ?? "Unknown", tarotMeaning: newTarot.tarotMeaning ?? "Unknown", tarotDesc: newTarot.tarotDesc ?? "Unknown", date: today)
            updateUI(with: newTarot)
        }
    }

    // Update the UI with the tarot card data
    func updateUI(with tarotCard: TarotCardData) {
        tarotNameLabel.text = tarotCard.tarotName
        tarotStateLabel.text = tarotCard.tarotState
        tarotMeaningText.text = tarotCard.tarotMeaning
        tarotDescText.text = tarotCard.tarotDesc
        
        // Set an image for the tarot card
        if let tarotName = tarotCard.tarotName {
            tarotImage.image = UIImage(named: tarotName.lowercased())
        } else {
            tarotImage.image = nil
        }
    }
    
    func generateTarotForToday() -> TarotCardData {
        // Implement the logic to generate a tarot card
        let tarotName = "HI"
        let tarotState = "UP"
        let tarotMeaning = "Good"
        let tarotDesc = "Very Good"
        let date = Date()
        
        // Add the generated tarot card to the database
        guard let tarotCard = databaseController?.addTarotCardData(tarotName: tarotName, tarotState: tarotState, tarotMeaning: tarotMeaning, tarotDesc: tarotDesc, date: date) else {
            fatalError("Failed to generate tarot card")
        }
        
        return tarotCard
    }
    
    func scheduleDailyNotification() {
        let center = UNUserNotificationCenter.current()
        
        // Calculate tomorrow's date
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        
        // Check if there is already a tarot card for tomorrow
        if databaseController?.getDailyTarotCard(for: tomorrow) == nil {
            // Generate a new tarot card for tomorrow
            let newTarot = generateTarotForToday()
            
            // Schedule the notification
            let content = UNMutableNotificationContent()
            content.title = "Your Daily Tarot"
            content.body = newTarot.tarotMeaning ?? "error"
            content.sound = .default
            
            // Configure the recurring date
            var dateComponents = DateComponents()
            dateComponents.hour = 9 // 9:00 AM
            
            // Create the trigger as a repeating event
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            // Create the request
            let request = UNNotificationRequest(identifier: "dailyTarotNotification", content: content, trigger: trigger)
            
            // Schedule the request with the notification center
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                } else {
                    print("Daily tarot notification scheduled for 9:00 AM every day.")
                }
            }
        }
    }
}
