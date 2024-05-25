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
    func onTarotChange(change: DatabaseChange, dailyTarot: [TarotCardData])
    func onHoroScopeChange(change: DatabaseChange, dailyHoroscope: [TarotCardData] )
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    //Tarot card functions
    func addTarotCardData(tarotName: String, tarotState: Int32, tarotMeaning: String, tarotDesc: String, date: String)
    -> TarotCardData
    func getDailyTarotCard(for date: String) -> TarotCardData? 
    func deleteTarotCardData(tarotCard: TarotCardData)
    //Horoscope functions
    func addHoroscopeData(starSign: String, date: String, desc: String) -> HoroscopeData
    func deleteHoroscopeData(horoscope: HoroscopeData)
}
