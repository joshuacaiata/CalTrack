//
//  TrackerModel.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/13/24.
//

import Foundation

struct Tracker {
    let targetCalories: Int = 2250
    var entries: EntryList
    
    init(entries: EntryList = EntryList(entries: [Entry(name: "Apple", consume: true, kcalCount: 300)])) {
        self.entries = entries
    }
    
    var consumedCalories: Int {
        var total = 0
        
        for entry in entries.entries {
            if entry.consume {
                total += entry.kcalCount
            }
        }
        
        return total
    }
    
    var burnedCalories: Int {
        var total = 0
        
        for entry in entries.entries {
            if !entry.consume {
                total += entry.kcalCount
            }
        }
        
        return total
    }
    
    var net: Int {
        return targetCalories + burnedCalories - consumedCalories
    }
    
    var percentComplete: Float {
        return Float(consumedCalories) / (Float(targetCalories) + Float(burnedCalories))
    }
    
}
