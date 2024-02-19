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
    
    var body: some View {
        VStack {
            SummaryView(viewModel: TrackerViewModel())
            
            EntryListView(viewModel: EntryListViewModel())
            
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
            AddEntryView()
        }
    }
}

#Preview {
    MainView()
}
