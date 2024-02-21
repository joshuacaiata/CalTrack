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
    
    @ObservedObject var entryListViewModel: EntryListViewModel
    @ObservedObject var trackerViewModel: TrackerViewModel

    init() {
        let entryListVM = EntryListViewModel()
        self.entryListViewModel = entryListVM
        self.trackerViewModel = TrackerViewModel(entryList: entryListVM)
    }
    
    var body: some View {
        VStack {
            SummaryView(viewModel: trackerViewModel)
            
            EntryListView(viewModel: entryListViewModel)
            
            Spacer()
            
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
        .sheet(isPresented: $showingPopup) {
            AddEntryView(viewModel: entryListViewModel, showingPopup: $showingPopup)
        }
    }
}

#Preview {
    MainView()
}
