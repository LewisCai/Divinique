//
//  ReadingProtocol.swift
//  Divinique
//
//  Created by LinjunCai on 23/5/2024.
//

import Foundation

protocol ReadingProtocol: AnyObject{
    func fetchRandomCard(numOfCard: Int) async -> [TarotCard]
    func dateFormatter(date: Date) -> String
}
