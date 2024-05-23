//
//  CoreDataController.swift
//  Divinique
//
//  Created by LinjunCai on 23/5/2024.
//

import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol {
    
    
    var persistentContainer: NSPersistentContainer
    var listeners = MulticastDelegate<DatabaseListener>()
    
    override init() {
        persistentContainer = NSPersistentContainer(name: "DiviniqueData")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data Stack with error: \(error)")
            }
        }
        super.init()
    }

    func cleanup() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save changes to Core Data with error: \(error)")
            }
        }
    }

    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
    }

    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }

    func addTarotCardData(tarotName: String, tarotState: Int32, tarotMeaning: String, tarotDesc: String, date: Date) -> TarotCardData {
        let context = persistentContainer.viewContext
        let tarotCard = TarotCardData(context: context)
        tarotCard.tarotName = tarotName
        tarotCard.tarotState = tarotState
        tarotCard.tarotMeaning = tarotMeaning
        tarotCard.tarotDesc = tarotDesc

        saveContext()
        return tarotCard
    }

    func deleteTarotCardData(tarotCard: TarotCardData) {
        let context = persistentContainer.viewContext
        context.delete(tarotCard)
        saveContext()
    }

    func addHoroscopeData(starSign: String, date: Date, desc: String) -> HoroscopeData {
        let context = persistentContainer.viewContext
        let horoscope = HoroscopeData(context: context)
        horoscope.starSign = starSign
        horoscope.date = date
        horoscope.desc = desc

        saveContext()
        return horoscope
    }

    func deleteHoroscopeData(horoscope: HoroscopeData) {
        let context = persistentContainer.viewContext
        context.delete(horoscope)
        saveContext()
    }

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
    
    func getDailyTarotCard(for date: Date) -> TarotCardData? {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<TarotCardData> = TarotCardData.fetchRequest()
        request.predicate = NSPredicate(format: "date == %@", date as NSDate)
        do {
            return try context.fetch(request).first
        } catch {
            print("Failed to fetch daily tarot: \(error)")
            return nil
        }
    }

    func fetchAllTarotCards() -> [TarotCardData] {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<TarotCardData> = TarotCardData.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch tarot cards: \(error)")
            return []
        }
    }

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
