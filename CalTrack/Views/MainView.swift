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
    
    // This tracks information like calories burnt, consumed, etc.
    @StateObject var trackerViewModel: TrackerViewModel
    var entryListViewModel: EntryListViewModel
    var dateViewModel: DateViewModel
    
    init() {
        var dateVM = DateViewModel()
        var entryListVM = EntryListViewModel(dateViewModel: dateVM)
        var trackerVM = TrackerViewModel(entryList: entryListVM)
        
        _trackerViewModel = StateObject(wrappedValue: trackerVM)
        self.entryListViewModel = entryListVM
        self.dateViewModel = dateVM
    }
    
    
    var body: some View {
        VStack {
            // Call the summary view (big blue box)
            SummaryView(trackerViewModel: trackerViewModel)
            
            // Call the view for the entry list
            EntryListView(viewModel: entryListViewModel)
            
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
                        .background(Circle().fill(AppColors.CalTrackNegative))
                }
                
                Spacer()

            }
            
        }
        // to pull up the sheet when you click +
        .sheet(isPresented: $showingPopup) {
            AddEntryView(viewModel: entryListViewModel, showingPopup: $showingPopup)
                .preferredColorScheme(.light)
        }
        .background(Color.white)
    }
}

#Preview {
    MainView()
}
