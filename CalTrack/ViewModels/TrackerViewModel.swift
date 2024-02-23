//
//  TrackerViewModel.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/13/24.
//

import Foundation
import SwiftUI
import Combine

class TrackerViewModel: ObservableObject {
    // Holds the list of entries
    var entryList: EntryListViewModel
    
    // Set to keep track of Combine subscriptions to manage memory
    private var entryListCancellables = Set<AnyCancellable>()
    
    private var dateViewCancellables = Set<AnyCancellable>()
        
    // Default calorie goal
    var target = 2250
    
    // Initializer for the class, allowing for dependency injection
    init(entryList: EntryListViewModel) {
        self.entryList = entryList
                
        // Calls a method to start observing changes in the entry list
        observeEntryListChanges()
        
        observeDateViewChanges()
    }

    // Calculates number of consumed calories
    var consumedCalories: Int {
        var total = 0
        
        for entry in entryList.todaysEntries {
            if entry.consume {
                total += entry.kcalCount
            }
        }
        
        return total
    }
    
    // Calculates number of burned calories
    var burnedCalories: Int {
        var total = 0
        
        for entry in entryList.todaysEntries {
            if !entry.consume {
                total += entry.kcalCount
            }
        }
        
        return total
    }
    
    // Calculates net calories
    var net: Int {
        return target + burnedCalories - consumedCalories
    }
    
    // Calculates percent completed
    var percentComplete: Float {
        return Float(consumedCalories) / (Float(target) + Float(burnedCalories))
    }
    
    // This makes the class observe changes in the entry list and update the model accordingly
    private func observeEntryListChanges() {
        // observes the info publisher from the entry list
        entryList.$info
            // whenever the info changes, it triggers the objectWillChange publisher to notify SwiftUI that it needs to update the view
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            // Stores the subscription in the cancellables set to manage lifecycle
            .store(in: &entryListCancellables)
    }
    
    private func observeDateViewChanges() {
        entryList.dateViewModel.$selectedDate
            .sink { [weak self] _ in
                self?.objectWillChange.send()
                self?.entryList.loadEntries()
            }
            .store(in: &dateViewCancellables)
    }
}
