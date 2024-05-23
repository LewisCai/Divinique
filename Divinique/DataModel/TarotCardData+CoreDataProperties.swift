//
//  TarotCardData+CoreDataProperties.swift
//  Divinique
//
//  Created by LinjunCai on 23/5/2024.
//
//

import Foundation
import CoreData


extension TarotCardData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TarotCardData> {
        return NSFetchRequest<TarotCardData>(entityName: "TarotCardData")
    }

    @NSManaged public var tarotName: String?
    @NSManaged public var tarotState: String?
    @NSManaged public var tarotMeaning: String?
    @NSManaged public var tarotDesc: String?
    @NSManaged public var date: Date?
}

extension TarotCardData : Identifiable {

}
