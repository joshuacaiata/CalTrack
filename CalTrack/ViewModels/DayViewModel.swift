//
//  DayViewModel.swift
//  CalTrack-Refactored
//
//  Created by Joshua Caiata on 3/13/24.
//

import Foundation
import Combine

class DayViewModel: ObservableObject {
    @Published var dayModel: Day
    
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
    
    var date: Date { dayModel.date }
    
    var entryList: EntryList { dayModel.entryList }
    
    init(day: Day) {
        self.dayModel = day
        
        let savedTarget = UserDefaults.standard.integer(forKey: "targetCalories").nonZeroDefault(2250)
        
        self.target = savedTarget
        self.targetString = "\(self.target)"
        
        self.healthKitManager = HealthKitManager()
    }
    
    func configureHealthKitManager() async -> Int {
        var totalActiveCalories: Int = 0
        
        totalActiveCalories = await healthKitManager?.fetchTotalActiveCalories(for: dayModel.date) ?? 0
        
        return totalActiveCalories
    }
    
    func addEntry(entry: Entry) {
        var updatedInfo = self.dayModel
        updatedInfo.entryList.entries.append(entry)
        self.dayModel = updatedInfo
    }
    
    func deleteEntries(at offsets: IndexSet) {
        var updatedInfo = self.dayModel
        offsets.forEach { index in
            updatedInfo.entryList.entries.remove(at: index)
        }
        self.dayModel = updatedInfo // This triggers the publisher
    }
    
    func updateCalculations() {
        UserDefaults.standard.set(self.target, forKey: "targetCalories")
        self.dayModel.target = self.target
    }
}
