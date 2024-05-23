//
//  HoroscopeData+CoreDataProperties.swift
//  Divinique
//
//  Created by LinjunCai on 23/5/2024.
//
//

import Foundation
import CoreData


extension HoroscopeData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HoroscopeData> {
        return NSFetchRequest<HoroscopeData>(entityName: "HoroscopeData")
    }

    @NSManaged public var starSign: String?
    @NSManaged public var date: Date?
    @NSManaged public var desc: String?

}

extension HoroscopeData : Identifiable {

}
