//
//  HoroscopeData+CoreDataProperties.swift
//  Divinique
//
//  Created by LinjunCai on 24/5/2024.
//
//

import Foundation
import CoreData


extension HoroscopeData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HoroscopeData> {
        return NSFetchRequest<HoroscopeData>(entityName: "HoroscopeData")
    }

    @NSManaged public var date: String?
    @NSManaged public var desc: String?
    @NSManaged public var starSign: String?

}

extension HoroscopeData : Identifiable {

}
