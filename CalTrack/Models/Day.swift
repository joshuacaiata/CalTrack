//
//  Day.swift
//  CalTrack
//
//  Created by Joshua Caiata on 3/13/24.
//

import Foundation
import Combine

// Contains information about a day, like the date, target, and healthkit active
//      calories.
// Parent: DateManager
// Children: EntryList
struct Day: Codable {
    var entryList: EntryList
    var date: Date
    var totalHealthKitActiveCalories: Int = 0
    
    var target: Int = 2250
    
    var netHealthKitWorkoutCalories: Int {
        totalHealthKitActiveCalories - entryList.healthKitWorkoutCalories
    }
    var netCalories: Int {
        target + entryList.burnedCalories + totalHealthKitActiveCalories - entryList.consumedCalories - entryList.healthKitWorkoutCalories
    }
    var percentComplete: Float {
        Float(entryList.consumedCalories) / (Float(target) + Float(entryList.burnedCalories) + Float(totalHealthKitActiveCalories) - Float(entryList.healthKitWorkoutCalories))
    }
    
    var formattedCurrentDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM dd"
        return dateFormatter.string(from: date)
    }
    
    init(date: Date) {
        self.date = date
        self.entryList = EntryList()
    }
}

extension Int {
    func nonZeroDefault(_ defaultValue: Int) -> Int {
        return self == 0 ? defaultValue : self
    }
}
