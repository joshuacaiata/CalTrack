//
//  EntryListViewModel.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/16/24.
//

import Foundation

class EntryListViewModel: ObservableObject {
    // Publish the Entry List to observers
    @Published var info = EntryList()
    
    // Create the entries field
    var entries: [EntryViewModel] {
        info.entries.map {
            EntryViewModel(name: $0.name, consume: $0.consume, kcalCount: $0.kcalCount)
        }
    }
    
    // Ability to add entries
    func addEntry(entry: EntryViewModel) {
        info.entries.append(entry.info)
    }
    
    // Ability to delete entries at indices
    func deleteEntries(at offsets: IndexSet) {
        for offset in offsets {
            info.entries.remove(at: offset)
        }
    }
}
