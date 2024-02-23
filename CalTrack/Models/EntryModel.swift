//
//  EntryModel.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/13/24.
//

import Foundation

struct Entry: Hashable, Codable {
    var name: String
    var consume: Bool
    var kcalCount: Int
    var date: Date
}
