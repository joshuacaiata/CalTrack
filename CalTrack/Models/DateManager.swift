//
//  DateManager.swift
//  CalTrack-Refactored
//
//  Created by Joshua Caiata on 3/14/24.
//

import Foundation
import Combine

/*
 Manages the different days and storing them in memory
 Parent: None
 Children: Day
 */
struct DateManager: Codable {
    var selectedDay: Day
    var currentDate: Date
    var dates: [Date: Day] = [:]

    init(startingDate: Date) {
        self.currentDate = startingDate

        // Normalize the day to be the start of the day so we always call equivalent things
        let normalizedStartDate = DateManager.normalizeDate(startingDate)
        
        // If we don't have that day already, then create one
        if self.dates[normalizedStartDate] == nil {
            self.dates[normalizedStartDate] = Day(date: startingDate)
        }
        
        // Set selected day to the day stored at the startingDate in dates
        self.selectedDay = self.dates[normalizedStartDate] ?? Day(date: startingDate)
    }
    
    // Set the date to the start of the date, ignore time
    static func normalizeDate(_ date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let normalizedDate = calendar.date(from: components)!
        return normalizedDate
    }
    
    // Load a day from the dictionary
    mutating func loadDay(date: Date) -> Day {
        let normalizedDate = DateManager.normalizeDate(date)
        if dates[normalizedDate] == nil {
            // Create a new Day instance for the given date
            let newDay = Day(date: date)
            
            // Save the new Day instance in the dictionary
            dates[normalizedDate] = newDay
        }

        return dates[normalizedDate]!
    }
}

