//
//  EntryListViewModel.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/16/24.
//

import Foundation

class EntryListViewModel: ObservableObject {
    @Published var info = EntryList()
    
    var entries: [Entry] {
        info.entries
    }
}
