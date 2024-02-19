//
//  EntryListModel.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/13/24.
//

import Foundation

struct EntryList {
    var entries: [Entry] = [Entry(name: "Apple", consume: true, kcalCount: 100), Entry(name: "Run", consume: false, kcalCount: 200), Entry(name: "Run", consume: false, kcalCount: 200), Entry(name: "Run", consume: false, kcalCount: 200), Entry(name: "Run", consume: false, kcalCount: 200), Entry(name: "Run", consume: false, kcalCount: 200), Entry(name: "Run", consume: false, kcalCount: 200), Entry(name: "Run", consume: false, kcalCount: 200), Entry(name: "Run", consume: false, kcalCount: 200)]
    
    mutating func addEntry(new: Entry) {
        entries.append(new)
    }
}
