//
//  MainView.swift
//  CalTrack-Refactored
//
//  Created by Joshua Caiata on 3/13/24.
//

import SwiftUI
import Foundation

struct MainView: View {
    @State private var showingPopup = false
    
    @StateObject var dateManagerViewModel: DateManagerViewModel
    var dayViewModel: DayViewModel { dateManagerViewModel.selectedDayViewModel }
    
    init() {
        var dateManager: DateManager? = nil
        if let loadedDateManager = PersistenceManager.shared.loadDateManager() {
            dateManager = loadedDateManager
        } else {
            dateManager = DateManager(startingDate: Date())
        }
        
        PersistenceManager.shared.saveDateManager(dateManager: dateManager!)
        
        let dateManagerViewModel = DateManagerViewModel(dateManager: dateManager!)
        dateManagerViewModel.setDay(to: Date())
        
        _dateManagerViewModel = StateObject(wrappedValue: dateManagerViewModel)
    }
    
    var body: some View {
        VStack {
            // Call the summary view (big blue box)
            SummaryView(dateManagerViewModel: dateManagerViewModel)
            
            // Call the view for the entry list
            EntryListView(dateManagerViewModel: dateManagerViewModel)
            
            Spacer()
            
            HStack {
                Spacer()
                
                // Button to add entries
                Button(action: {
                    showingPopup = true
                }) {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(AppColours.CalTrackNegative))
                }
                
                Spacer()

            }
            
        }
        
        // to pull up the sheet when you click +
        .sheet(isPresented: $showingPopup) {
            AddEntryView(dateManagerViewModel: dateManagerViewModel, showingPopup: $showingPopup)
                .preferredColorScheme(.light)
        }
        .background(Color.white)
    }
}


#Preview {
    MainView()
}

