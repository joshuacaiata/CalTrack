//
//  EntryManager.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/21/24.
//

import Foundation

// Handles clearing entries when needed
class EntryManager {
    static let shared = EntryManager()
        
    // Clear entries
    func clearEntries() {
        // Create new entry
        let emptyList = EntryList()
        
        // Save the entry
        PersistenceManager.shared.saveEntryList(entryList: emptyList)
    }
}
