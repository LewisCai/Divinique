//
//  DailyTarotViewController.swift
//  Divinique
//
//  Created by LinjunCai on 23/5/2024.
//

import UIKit
import CoreData

class DailyTarotViewController: UIViewController {
    var databaseController: DatabaseProtocol?
    var coredataController: CoreDataController?
    var readingController: ReadingProtocol?
    
    
    @IBOutlet weak var tarotNameLabel: UILabel!
    
    @IBOutlet weak var tarotImage: UIImageView!
    
    @IBOutlet weak var tarotStateLabel: UILabel!
    
    @IBOutlet weak var tarotMeaningText: UITextView!
    
    @IBOutlet weak var tarotDescText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        readingController = appDelegate?.readingController
        // Launch the async task
        Task {
            await displayTodayTarot()
        }
        
        Task {
            await scheduleDailyNotification()
        }
    }
    
    // Display today's tarot card by searching for a card in the database that has today's date
    func displayTodayTarot() async {
        //get today's year month and day
        let today_date = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
        let today_string = readingController?.dateFormatter(date: today_date)
        
        if let tarotCard = databaseController?.getDailyTarotCard(for: today_string!){
            print("found")
            let newTarot = TarotCard(name: tarotCard.tarotName!,
                                     state: tarotCard.tarotState,
                                     meaning: tarotCard.tarotMeaning!,
                                     desc: tarotCard.tarotDesc!,
                                     date: tarotCard.date!)
            updateUI(with: newTarot)
        } else {
            print("No tarot card found for today's date, generating a new one.")
            let newTarot = await readingController?.fetchRandomCard(numOfCard: 1).first
            let _ = databaseController?.addTarotCardData(tarotName: newTarot?.name ?? "Unknown", tarotState: (newTarot?.state ?? 1) as Int32, tarotMeaning: newTarot?.meaning ?? "Unknown", tarotDesc: newTarot?.desc ?? "Unknown", date: today_string ?? "Unknown")
            updateUI(with: newTarot!)
        }
    }
    
    func scheduleDailyNotification() async {
        let center = UNUserNotificationCenter.current()
        
        // Calculate tomorrow's date
        let tomorrow_date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let tomorrow_string = readingController?.dateFormatter(date: tomorrow_date)
        
        
        // Check if there is already a tarot card for tomorrow
        if databaseController?.getDailyTarotCard(for: tomorrow_string!) == nil {
            // Generate a new tarot card for tomorrow
            let newTarot = await readingController?.fetchRandomCard(numOfCard: 1)
            
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
}
