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
    weak var readingController: ReadingProtocol?
    
    
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
        readingController = appDelegate?.readingController
        displayTodayTarot()
        scheduleDailyNotification()
    }
    
    // Display today's tarot card by searching for a card in the database that has today's date
    func displayTodayTarot() {
        let today = Date()
        let tarotCards = coredataController?.fetchAllTarotCards() ?? []

        if let storedTarot = tarotCards.first(where: { $0.date == today }) {
            var newTarot = TarotCard(name: storedTarot.tarotName!, state: storedTarot.tarotState as! Int32, meaning: storedTarot.tarotMeaning!, desc: storedTarot.tarotDesc!, date: storedTarot.date!)
        } else {
            print("No tarot card found for today's date, generating a new one.", readingController)
            var newTarot = readingController?.fetchRandomCard(numOfCard: 1).first
            databaseController?.addTarotCardData(tarotName: newTarot?.name ?? "Unknown", tarotState: (newTarot?.state ?? 1) as Int32, tarotMeaning: newTarot?.meaning ?? "Unknown", tarotDesc: newTarot?.desc ?? "Unknown", date: today)
            updateUI(with: newTarot!)
        }
    }

    // Update the UI with the tarot card data
    func updateUI(with tarotCard: TarotCard) {
        tarotNameLabel.text = tarotCard.name
        tarotStateLabel.text = tarotCard.state == 1 ? "Up" : "Reverse"
        tarotMeaningText.text = tarotCard.meaning
        tarotDescText.text = tarotCard.desc
        
        // Set an image for the tarot card
        let tarotName = tarotCard.name
        tarotImage.image = UIImage(named: tarotName.lowercased())
    }
    
    func scheduleDailyNotification() {
        let center = UNUserNotificationCenter.current()
        
        // Calculate tomorrow's date
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        
        // Check if there is already a tarot card for tomorrow
        if databaseController?.getDailyTarotCard(for: tomorrow) == nil {
            // Generate a new tarot card for tomorrow
            let newTarot = readingController?.fetchRandomCard(numOfCard: 1)
            
            // Schedule the notification
            let content = UNMutableNotificationContent()
            content.title = "Your Daily Tarot"
            content.body = newTarot?.first?.desc ?? "error"
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
