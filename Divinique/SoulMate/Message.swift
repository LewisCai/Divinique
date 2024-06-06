//
//  Message.swift
//  Divinique
//
//  Created by LinjunCai on 6/6/2024.
//

import Foundation

struct Message: Codable {
    var sender: String
    var text: String
    var timestamp: Date
}
