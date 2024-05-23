//
//  DatabaseProtocol.swift
//  Divinique
//
//  Created by LinjunCai on 23/5/2024.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case tarot
    case horoscope
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onTarotChange(change: DatabaseChange, dailyTarot: TarotCardData)
    func onHoroScopeChange(change: DatabaseChange, dailyHoroscope: HoroscopeData )
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    //Tarot card functions
    func addTarotCardData(tarotName: String, tarotState: String, tarotMeaning: String, tarotDesc: String, date: Date)
    -> TarotCardData
    func getDailyTarotCard(for date: Date) -> TarotCardData? 
    func deleteTarotCardData(tarotCard: TarotCardData)
    //Horoscope functions
    func addHoroscopeData(starSign: String, date: Date, desc: String) -> HoroscopeData
    func deleteHoroscopeData(horoscope: HoroscopeData)
}
