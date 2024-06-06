//
//  User.swift
//  Divinique
//
//  Created by LinjunCai on 6/6/2024.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable {
    var userId: String
    var name: String
    var date: String
    var sign: String
    var latitude: Double?
    var longitude: Double?
    var friends: [String]?
}
