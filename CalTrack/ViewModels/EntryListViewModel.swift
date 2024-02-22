//
//  EntryListViewModel.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/16/24.
//

import Foundation
import Combine

class EntryListViewModel: ObservableObject {
    // Publish the Entry List to observers
    @Published var info = EntryList() {
        didSet {
            saveEntries()
        }
    }
    
    var timerSubscription: AnyCancellable?
    
    // Initializer which loads previous entries
    init() {
        
        // Run newDayProtocol from DateManager to check if we need to reset
        DateManager.shared.newDayProtocol()
        
        loadEntries()
    }
    
    // Create the entries field
    var entries: [EntryViewModel] {
        info.entries.map {
            EntryViewModel(name: $0.name, consume: $0.consume, kcalCount: $0.kcalCount)
        }
    }
    
    // Ability to add entries
    func addEntry(entry: EntryViewModel) {
        info.entries.append(entry.info)
        // didSet will call saveEntries() on changes
    }
    
    // Ability to delete entries at indices
    func deleteEntries(at offsets: IndexSet) {
        for offset in offsets {
            info.entries.remove(at: offset)
            // didSet will call saveEntries() on changes
        }
    }
    
    // Calling datamanager's saveEntryList method, passing in the info field
    private func saveEntries() {
        PersistenceManager.shared.saveEntryList(entryList: info)
    }
    
    private func loadEntries() {
        if let loadedEntryList = PersistenceManager.shared.loadEntryList() {
            DispatchQueue.main.async {
                self.info = loadedEntryList
            }
        }
    }
    
    private func clearEntries() {
        self.info = EntryList()
        saveEntries()
    }
}
