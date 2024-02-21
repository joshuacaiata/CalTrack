//
//  EntryListViewModel.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/16/24.
//

import Foundation

class EntryListViewModel: ObservableObject {
    @Published var info = EntryList()
    
    var entries: [EntryViewModel] {
        info.entries.map {
            EntryViewModel(name: $0.name, consume: $0.consume, kcalCount: $0.kcalCount)
        }
    }
    
    func addEntry(entry: EntryViewModel) {
        info.entries.append(entry.info)
    }
    
    func deleteEntries(at offsets: IndexSet) {
        for offset in offsets {
            info.entries.remove(at: offset)
        }
    }
}
