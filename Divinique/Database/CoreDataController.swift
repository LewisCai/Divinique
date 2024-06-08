//
//  CoreDataController.swift
//  Divinique
//
//  Created by LinjunCai on 23/5/2024.
//

import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate{
    var allTarotFetchedResultsController: NSFetchedResultsController<TarotCardData>?
    var persistentContainer: NSPersistentContainer
    var listeners = MulticastDelegate<DatabaseListener>()
    
    // Initialize the Core Data stack
    override init() {
        persistentContainer = NSPersistentContainer(name: "DiviniqueCoreDataModel")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data Stack with error: \(error)")
            }
        }
        super.init()
    }

    // Save any changes in the context
    func cleanup() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save changes to Core Data with error: \(error)")
            }
        }
    }

    // Add a listener to the multicast delegate
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == .tarot || listener.listenerType == .all {
            listener.onTarotChange(change: .update, dailyTarot: fetchAllTarotCards())
        }
    }

    // Remove a listener from the multicast delegate
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }

    // Add a new TarotCardData entry to Core Data
    func addTarotCardData(tarotName: String, tarotState: Int32, tarotMeaning: String, tarotDesc: String, date: String) -> TarotCardData {
        print("adding a card")
        let tarotCard = NSEntityDescription.insertNewObject(forEntityName: "TarotCardData", into: persistentContainer.viewContext) as! TarotCardData
        tarotCard.tarotName = tarotName
        tarotCard.tarotState = tarotState
        tarotCard.tarotMeaning = tarotMeaning
        tarotCard.tarotDesc = tarotDesc
        tarotCard.date = date

        saveContext()
        return tarotCard
    }

    // Delete a TarotCardData entry from Core Data
    func deleteTarotCardData(tarotCard: TarotCardData) {
        let context = persistentContainer.viewContext
        context.delete(tarotCard)
        saveContext()
    }

    // Add a new HoroscopeData entry to Core Data
    func addHoroscopeData(starSign: String, date: String, desc: String) -> HoroscopeData {
        let context = persistentContainer.viewContext
        let horoscope = HoroscopeData(context: context)
        horoscope.starSign = starSign
        horoscope.date = date
        horoscope.desc = desc

        saveContext()
        return horoscope
    }

    // Delete a HoroscopeData entry from Core Data
    func deleteHoroscopeData(horoscope: HoroscopeData) {
        let context = persistentContainer.viewContext
        context.delete(horoscope)
        saveContext()
    }

    // Save changes to the context if there are any
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Failed to save changes to Core Data with error: \(error)")
            }
        }
    }
    
    // Fetch the daily tarot card for a specific date
    func getDailyTarotCard(for date: String) -> TarotCardData? {
        print("get card", date)
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<TarotCardData>(entityName: "TarotCardData")
        request.predicate = NSPredicate(format: "date == %@", date)
        do {
            return try context.fetch(request).first
        } catch {
            print("Failed to fetch daily tarot: \(error)")
            return nil
        }
    }

    // Fetch all TarotCardData entries from Core Data
    func fetchAllTarotCards() -> [TarotCardData] {
        print("fetching")
        var cards = [TarotCardData]()
        let request: NSFetchRequest<TarotCardData> = TarotCardData.fetchRequest()
        do {
            cards = try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch Request failed with error: \(error)")
        }
        return cards
    }

    // Fetch all HoroscopeData entries from Core Data
    func fetchAllHoroscopes() -> [HoroscopeData] {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<HoroscopeData> = HoroscopeData.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch horoscopes: \(error)")
            return []
        }
    }
}
