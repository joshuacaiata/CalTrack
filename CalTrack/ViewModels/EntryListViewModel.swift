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
    
    @Published var dateViewModel: DateViewModel
    
    var timerSubscription: AnyCancellable?
    
    private var cancellables = Set<AnyCancellable>()
    
    // Initializer which loads previous entries
    init(dateViewModel: DateViewModel) {
        
        self.dateViewModel = dateViewModel
        
        dateViewModel.$selectedDate
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        loadEntries()
    }
    
    // Create the entries field
    var entries: [EntryViewModel] {
        info.entries.map {
            EntryViewModel(name: $0.name, consume: $0.consume, kcalCount: $0.kcalCount, date: $0.date)
        }
    }
    
    // Filter the entries by the date
    var todaysEntries: [EntryViewModel] {
        print("filerting entries queen!")
        return entries.filter { entryViewModel in
            Calendar.current.isDate(entryViewModel.info.date, inSameDayAs: dateViewModel.selectedDate)
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
