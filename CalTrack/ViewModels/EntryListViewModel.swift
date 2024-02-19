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
        info.entries.map { entry in
            EntryViewModel(name: entry.name, consume: entry.consume, kcalCount: entry.kcalCount)
        }
    }
}
