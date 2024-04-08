//
//  DateManager.swift
//  CalTrack-Refactored
//
//  Created by Joshua Caiata on 3/14/24.
//

import Foundation
import Combine

struct DateManager: Codable {
    var selectedDay: Day
    var currentDate: Date
    var dates: [Date: Day] = [:]

    init(startingDate: Date) {
        self.currentDate = startingDate

        // Move the normalization function call outside of the direct use of `self`.
        let normalizedStartDate = DateManager.normalizeDate(startingDate)

        if self.dates[normalizedStartDate] == nil {
            self.dates[normalizedStartDate] = Day(date: startingDate)
        }

        // Now, it is safe to use `normalizedStartDate` because it doesn't rely on `self`.
        self.selectedDay = self.dates[normalizedStartDate] ?? Day(date: startingDate)
    }

    static func normalizeDate(_ date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let normalizedDate = calendar.date(from: components)!
        return normalizedDate
    }

    mutating func loadDay(date: Date) -> Day {
        let normalizedDate = DateManager.normalizeDate(date)
        if dates[normalizedDate] == nil {
            // Create a new Day instance for the given date
            var newDay = Day(date: date)
            
            // Calculate the previous day
            let calendar = Calendar.current
            if let previousDate = calendar.date(byAdding: .day, value: -1, to: date) {
                let normalizedPreviousDate = DateManager.normalizeDate(previousDate)
                
                // If the previous day exists, set the new day's target to the previous day's target
                if let previousDay = dates[normalizedPreviousDate] {
                    newDay.target = previousDay.target
                }
            }
            
            // Save the new Day instance in the dictionary
            dates[normalizedDate] = newDay
        }

        return dates[normalizedDate]!
    }
}

