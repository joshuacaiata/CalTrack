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
    var entryList: EntryListViewModel
    
    private var cancellables = Set<AnyCancellable>()
        
    var target = 2250
    
    init(entryList: EntryListViewModel) {
        self.entryList = entryList
        observeEntryListChanges()
    }

    
    var consumedCalories: Int {
        var total = 0
        
        for entry in entryList.entries {
            if entry.consume {
                total += entry.kcalCount
            }
        }
        
        return total
    }
    
    var burnedCalories: Int {
        var total = 0
        
        for entry in entryList.entries {
            if !entry.consume {
                total += entry.kcalCount
            }
        }
        
        return total
    }
    
    var net: Int {
        return target + burnedCalories - consumedCalories
    }
    
    var percentComplete: Float {
        return Float(consumedCalories) / (Float(target) + Float(burnedCalories))
    }
    
    private func observeEntryListChanges() {
        entryList.$info
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables) // Correct usage
    }
}
