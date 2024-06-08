//
//  NotificationViewController.swift
//  Divinique
//
//  Created by LinjunCai on 7/6/2024.
//

import UIKit
import UserNotifications
import FirebaseAuth
import FirebaseFirestore

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var tarotNotificationSwitch: UISwitch!
    
    @IBOutlet weak var horoscopeNotificationSwitch: UISwitch!
    
    
    var databaseController: DatabaseProtocol?
    var readingController: ReadingProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize database and reading controllers
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        readingController = appDelegate?.readingController
        
        // Check the current notification status
        checkNotificationStatus()
    }
    
    @IBAction func tarotNotificationSwitchToggled(_ sender: UISwitch) {
        //turn on and off notification
        if sender.isOn {
            Task {
                await scheduleDailyNotification()
            }
        } else {
            removeDailyNotification()
        }
    }
    
    @IBAction func horoscopeNotificationSwitchToggled(_ sender: UISwitch) {
        if sender.isOn {
            Task {
                await scheduleDailyHoroscopeNotification()
            }
        } else {
            removeDailyHoroscopeNotification()
        }
    }
    
    //check if ther eis a notification pending
    func checkNotificationStatus() {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { (requests) in
            let isScheduled = requests.contains(where: { $0.identifier == "dailyTarotNotification" })
            DispatchQueue.main.async {
                self.tarotNotificationSwitch.isOn = isScheduled
            }
        }
    }
    
    func scheduleDailyNotification() async {
        let center = UNUserNotificationCenter.current()
        
        // Calculate tomorrow's date
        let tomorrow_date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let tomorrow_string = readingController?.dateFormatter(date: tomorrow_date)
        
        // Check if there is already a tarot card for tomorrow
        if databaseController?.getDailyTarotCard(for: tomorrow_string!) == nil {
            // Generate a new tarot card for tomorrow if not
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
    
    func removeDailyNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["dailyTarotNotification"])
        print("Daily tarot notification removed.")
    }
    
    func scheduleDailyHoroscopeNotification() async {
        let center = UNUserNotificationCenter.current()
        
        // Get current user ID
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        //get sign of user
        fetchUserSign(currentUserId: currentUserId) { userSign in
            guard let userSign = userSign else {
                print("User sign not found")
                return
            }
            
            // Fetch today's horoscope
            let today = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.string(from: today)
            
            Task {
                do {
                    guard let horoscope = try await self.fetchHoroscope(for: userSign, date: date, lang: "en") else {
                        print("Failed to fetch horoscope")
                        return
                    }
                    
                    // Schedule the notification
                    let content = UNMutableNotificationContent()
                    content.title = "Your Daily Horoscope"
                    content.body = horoscope.horoscope
                    content.sound = .default
                    
                    // Configure the recurring date
                    var dateComponents = DateComponents()
                    dateComponents.hour = 8 // 8:00 AM
                    
                    // Create the trigger as a repeating event
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    
                    // Create the request
                    let request = UNNotificationRequest(identifier: "dailyHoroscopeNotification", content: content, trigger: trigger)
                    
                    // Schedule the request with the notification center
                    center.add(request) { error in
                        if let error = error {
                            print("Error scheduling notification: \(error)")
                        } else {
                            print("Daily horoscope notification scheduled for 8:00 AM every day.")
                        }
                    }
                } catch {
                    print("Error fetching horoscope: \(error)")
                }
            }
        }
    }
    
    //Get user's sign from database
    func fetchUserSign(currentUserId: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").whereField("userId", isEqualTo: currentUserId).getDocuments { (snapshot, error) in
            guard let document = snapshot?.documents.first else {
                print("User document not found: \(String(describing: error))")
                completion(nil)
                return
            }
            
            if let sign = document.data()["sign"] as? String {
                completion(sign)
            } else {
                completion(nil)
            }
        }
    }
    
    func removeDailyHoroscopeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["dailyHoroscopeNotification"])
        print("Daily horoscope notification removed.")
    }
    
    //fetch horoscope info from API
    func fetchHoroscope(for sign: String, date: String, lang: String) async -> Horoscope? {
        let baseURLString = "https://newastro.vercel.app/\(sign)?date=\(date)&lang=\(lang)"
        
        guard let url = URL(string: baseURLString) else {
            print("Invalid URL")
            return nil
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return nil
            }
            
            let decoder = JSONDecoder()
            let horoscope = try decoder.decode(Horoscope.self, from: data)
            return horoscope
        } catch {
            print("Error fetching horoscope: \(error)")
            return nil
        }
    }
}
