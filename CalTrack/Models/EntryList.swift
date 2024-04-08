//
//  EntryList.swift
//  CalTrack
//
//  Created by Joshua Caiata on 3/13/24.
//

import Foundation

// The list of entries. Contains a list of the entries and high level aggregate
//      statistics about the entries
// Parent: Day
// Children: Entry
struct EntryList: Codable {
    var entries: [Entry]
    
    var consumedCalories: Int {
        var total = 0
        
        for entry in entries {
            if entry.consume {
                total += entry.kcalCount
            }
        }
        
        return total
    }
    
    var burnedCalories: Int {
        var total = 0
        
        for entry in entries {
            if !entry.consume {
                total += entry.kcalCount
            }
        }
        
        return total
    }
    
    var healthKitWorkoutCalories: Int {
        var total = 0
        
        for entry in entries {
            if !entry.consume && entry.apple {
                total += entry.kcalCount
            }
        }
        
        return total
    }
    
    init() {
        self.entries = []
    }
}
