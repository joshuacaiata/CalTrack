//
//  EntryListViewModel.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/16/24.
//

import Foundation

class EntryListViewModel: ObservableObject {
    // Publish the Entry List to observers
    @Published var info = EntryList() {
        didSet {
            saveEntries()
        }
    }
    
    // Initializer which loads previous entries
    init() {
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
        DataManager.shared.saveEntryList(entryList: info) { success in
            if success {
                print("Entries successfully saved.")
            } else {
                print("Entries failed to save")
            }
        }
    }
    
    private func loadEntries() {
        if let loadedEntryList = DataManager.shared.loadEntryList() {
            DispatchQueue.main.async {
                self.info = loadedEntryList
            }
        }
    }
}
