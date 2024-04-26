//
//  MainView.swift
//  CalTrack-Refactored
//
//  Created by Joshua Caiata on 3/13/24.
//

import SwiftUI
import Foundation

// The main view
// Contains the SummaryView, EntryListView, and also leads to the add entry flow
struct MainView: View {
    @State private var showingAddEntryView = false
    
    @StateObject var dateManagerViewModel: DateManagerViewModel
    var dayViewModel: DayViewModel { dateManagerViewModel.selectedDayViewModel }
    
    @Environment(\.colorScheme) var colorScheme
    
    var darkColor: Color {
        colorScheme == .dark ? AppColours.CalTrackNegativeDark : AppColours.CalTrackNegative
    }
    
    init() {
        var dateManager: DateManager? = nil
        if let loadedDateManager = PersistenceManager.shared.loadDateManager() {
            dateManager = loadedDateManager
        } else {
            dateManager = DateManager(startingDate: Date())
        }
        
        let database = DatabaseManager()
        
        PersistenceManager.shared.saveDateManager(dateManager: dateManager!)
        
        let dateManagerViewModel = DateManagerViewModel(dateManager: dateManager!, database: database)
        dateManagerViewModel.setDay(to: Date())
        
        _dateManagerViewModel = StateObject(wrappedValue: dateManagerViewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Call the summary view (big blue box)
                SummaryView(dateManagerViewModel: dateManagerViewModel)
                
                // Call the view for the entry list
                EntryListView(dateManagerViewModel: dateManagerViewModel)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    NavigationLink(destination: AddEntryView(dateManagerViewModel: dateManagerViewModel), label: {
                        Image(systemName: "plus")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(darkColor))
                    })

                    Spacer()
                    
                }
                
            }
        }
        .background(Color.white)
    }
}


#Preview {
    MainView()
}

