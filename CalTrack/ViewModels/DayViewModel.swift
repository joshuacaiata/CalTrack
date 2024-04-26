//
//  DayViewModel.swift
//  CalTrack-Refactored
//
//  Created by Joshua Caiata on 3/13/24.
//

import Foundation
import Combine

// ViewModel for the Day class
class DayViewModel: ObservableObject {
    @Published var dayModel: Day
    
    // Default calorie goal
    @Published var target: Int {
        didSet {
            UserDefaults.standard.set(target, forKey: "targetCalories")
            self.dayModel.target = self.target
        }
    }
    
    // Target string for typing into the textbok
    @Published var targetString: String = "2250" {
        didSet {
            if let newTarget = Int(targetString) {
                target = newTarget
            }
        }
    }
    
    // HealthKit service
    var healthKitManager: HealthKitManager?
    
    // Date of the Day model
    var date: Date { dayModel.date }
    
    // Day's entries
    var entryList: EntryList { dayModel.entryList }
    
    var database: DatabaseManager
    
    init(day: Day, database: DatabaseManager) {
        self.dayModel = day
        
        let savedTarget = UserDefaults.standard.integer(forKey: "targetCalories").nonZeroDefault(2250)
        
        self.database = database
        
        self.target = savedTarget
        self.targetString = "\(self.target)"
        
        self.healthKitManager = HealthKitManager()
    }
    
    func addEntry(entry: Entry) {
        var updatedInfo = self.dayModel
        updatedInfo.entryList.entries.append(entry)
        self.dayModel = updatedInfo
    }
    
    func deleteEntries(at offsets: IndexSet) {
        var updatedInfo = self.dayModel
        
        let idsToDelete = offsets.map { updatedInfo.entryList.entries[$0].id }
        
        offsets.forEach { index in
            updatedInfo.entryList.entries.remove(at: index)
        }
        self.dayModel = updatedInfo // This triggers the publisher
        
        idsToDelete.forEach { id in
            database.deleteEntry(withId: id)
        }
        database.printDatabase()
    }
}
