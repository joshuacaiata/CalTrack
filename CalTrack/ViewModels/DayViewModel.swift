//
//  DayViewModel.swift
//  CalTrack-Refactored
//
//  Created by Joshua Caiata on 3/13/24.
//

import Foundation
import Combine

class DayViewModel: ObservableObject {
    @Published var info: Day
    
    // Default calorie goal
    @Published var target: Int {
        didSet {
            UserDefaults.standard.set(target, forKey: "targetCalories")
            updateCalculations()
        }
    }
    
    @Published var targetString: String = "2250" {
        didSet {
            if let newTarget = Int(targetString) {
                target = newTarget
                updateCalculations()
            }
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    var healthKitManager: HealthKitManager?
    
    var date: Date { info.date }
    
    var entryList: EntryList { info.entryList }
    
    init(day: Day) {
        self.info = day
        
        self.target = day.target
        self.targetString = "\(self.target)"
        
        self.healthKitManager = HealthKitManager()
    }
    
    func configureHealthKitManager() async -> Int {
        let _ = await healthKitManager?.fetchWorkouts(for: info.date, dayViewModel: self)
        let totalActiveCalories = await healthKitManager?.fetchTotalActiveCalories(for: info.date)
        
        return totalActiveCalories ?? 0
    }
    
    func addEntry(entry: Entry) {
        var updatedInfo = self.info
        updatedInfo.entryList.entries.append(entry)
        self.info = updatedInfo
    }
    
    func deleteEntries(at offsets: IndexSet) {
        var updatedInfo = self.info
        offsets.forEach { index in
            updatedInfo.entryList.entries.remove(at: index)
        }
        self.info = updatedInfo // This triggers the publisher
    }
    
    func updateCalculations() {
        info.target = target
        UserDefaults.standard.set(target, forKey: "targetCalories")
    }
}
