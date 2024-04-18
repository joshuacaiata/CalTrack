//
//  EntryListView.swift
//  CalTrack-Refactored
//
//  Created by Joshua Caiata on 3/15/24.
//

import SwiftUI

struct EntryListView: View {
    @ObservedObject var dateManagerViewModel: DateManagerViewModel
    
    init(dateManagerViewModel: DateManagerViewModel) {
        self.dateManagerViewModel = dateManagerViewModel
    }
    
    var body: some View {
        List {
            if let healthKitManager = dateManagerViewModel.selectedDayViewModel.healthKitManager, 
                healthKitManager.healthKitAuthorized {
                EntryView(entry: Entry(id: UUID(), 
                          name: "Active Energy",
                          consume: false,
                          kcalCount: dateManagerViewModel.selectedDayViewModel.dayModel.netHealthKitWorkoutCalories,
                          apple: true))
                    .listRowInsets(EdgeInsets())
            }

            
            // iterate over everything in the entry list and make an entry view
            ForEach(dateManagerViewModel.selectedDayViewModel.entryList.entries, id: \.self) { entry in
                EntryView(entry: entry)
                    .listRowInsets(EdgeInsets())
            }
            // Handles deleting the item
            .onDelete { indexSet in
                dateManagerViewModel.selectedDayViewModel.deleteEntries(at: indexSet)
                dateManagerViewModel.saveDate()
            }
        }
        .listStyle(PlainListStyle())
        .padding(.horizontal, 30)
        .padding(.bottom, 30)
    }
}

#Preview {
    EntryListView(dateManagerViewModel: DateManagerViewModel(dateManager: DateManager(startingDate: Date())))
}
