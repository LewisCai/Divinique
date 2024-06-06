//
//  CustomAnnotation.swift
//  Divinique
//
//  Created by LinjunCai on 6/6/2024.
//

import Foundation
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var name: String?
    var date: String?
    var star: String?
    var userId: String?
    var currentUserId: String?
    
    
    init(coordinate: CLLocationCoordinate2D, name: String?, date: String?, star: String?, userId: String?, currentUserId: String?) {
        self.coordinate = coordinate
        self.name = name
        self.date = date
        self.star = star
        self.userId = userId
        self.currentUserId = currentUserId
    }
}
