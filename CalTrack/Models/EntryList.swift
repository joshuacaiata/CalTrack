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
    
    // Calculate number of consumed calories
    var consumedCalories: Int {
        var total = 0
        
        for entry in entries {
            if entry.consume {
                total += entry.kcalCount
            }
        }
        
        return total
    }
    
    // Calculate number of burned calories
    var burnedCalories: Int {
        var total = 0
        
        for entry in entries {
            if !entry.consume {
                total += entry.kcalCount
            }
        }
        
        return total
    }
    
    // Calculates calories from healthkit
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
