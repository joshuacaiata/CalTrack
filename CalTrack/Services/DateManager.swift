//
//  DateManager.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/21/24.
//

import Foundation

class DateManager {
    static let shared = DateManager()
    
    // Set the UserDefaults to the current date
    func updateLastActiveDate() {
        let currentDate = Date()
        UserDefaults.standard.set(currentDate, forKey: "lastActiveDate")
    }
    
    // Retrieve the last active date from user defaults, returns nil if none found
    func getLastActiveDate() -> Date? {
        UserDefaults.standard.object(forKey: "lastActiveDate") as? Date
    }
    
    // Check if current day is different from last, if so, clear entries
    func newDayProtocol() {
        // Get last active date
        guard let lastActiveDate = getLastActiveDate() else {
            // if no last active date set last active date to current
            print("there was no last active date")
            updateLastActiveDate()
            return
        }
        
        // Use Calendar to check if last active date is not the same as current date
        let calendar = Calendar.current
        if !calendar.isDateInToday(lastActiveDate) {
            // If its a new day, clear entries and update date
            print("its a new day, clearing entries")
            EntryManager.shared.clearEntries()
            updateLastActiveDate()
        } else {
            print("its not a new day")
        }
    }
}
