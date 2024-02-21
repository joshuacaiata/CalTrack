//
//  MainView.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/14/24.
//

import SwiftUI
import Foundation

struct MainView: View {
    @State private var showingPopup = false
    
    // This contains information regarding the Entry List
    @ObservedObject var entryListViewModel: EntryListViewModel
    
    // This tracks information like calories burnt, consumed, etc.
    @ObservedObject var trackerViewModel: TrackerViewModel

    // Initializes the Main view
    init() {
        let entryListVM = EntryListViewModel()
        self.entryListViewModel = entryListVM
        self.trackerViewModel = TrackerViewModel(entryList: entryListVM)
    }
    
    var body: some View {
        VStack {
            // Call the summary view (big blue box)
            SummaryView(viewModel: trackerViewModel)
            
            // Call the view for the entry list
            EntryListView(viewModel: entryListViewModel)
            
            Spacer()
            
            // Button to add entries
            Button(action: {
                showingPopup = true
            }) {
                Image(systemName: "plus")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding()
                                .background(Circle().fill(AppColors.CalTrackNegative))
            }
            
        }
        // to pull up the sheet when you click +
        .sheet(isPresented: $showingPopup) {
            AddEntryView(viewModel: entryListViewModel, showingPopup: $showingPopup)
        }
    }
}

#Preview {
    MainView()
}
