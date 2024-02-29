//
//  EntryListModel.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/13/24.
//

import Foundation

struct EntryList: Codable {
    var entries: [Entry] = []
    
    mutating func addEntry(new: Entry) {
        entries.append(new)
    }
}
