//
//  EntryModel.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/13/24.
//

import Foundation

struct Entry: Hashable, Codable, Identifiable {
    let id: UUID
    var name: String
    var consume: Bool
    var kcalCount: Int
    var date: Date

    // If you have a custom initializer that provides a default value for `id`,
    // make sure it doesn't conflict with decoding.
    init(id: UUID, name: String, consume: Bool, kcalCount: Int, date: Date) {
        self.id = id
        self.name = name
        self.consume = consume
        self.kcalCount = kcalCount
        self.date = date
    }
}

