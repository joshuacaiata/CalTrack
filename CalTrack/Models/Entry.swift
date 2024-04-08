//
//  Entry.swift
//  CalTrack-Refactored
//
//  Created by Joshua Caiata on 3/13/24.
//

import Foundation
import SwiftUI


// The base struct, info for a single entry
// Parent: EntryList
// Children: N/A
struct Entry: Hashable, Codable {
    let id: UUID
    var name: String
    var consume: Bool
    var kcalCount: Int
    var apple: Bool
    
    var calColor: Color {
        consume ? AppColours.CalTrackNegative : AppColours.CalTrackPositive
    }
    
    init(id: UUID, name: String, consume: Bool, kcalCount: Int, apple: Bool) {
        self.id = id
        self.name = name
        self.consume = consume
        self.kcalCount = kcalCount
        self.apple = apple
    }
}
