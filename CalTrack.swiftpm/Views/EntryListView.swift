//
//  EntryList.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/16/24.
//

import SwiftUI

struct EntryListView: View {
    @ObservedObject var viewModel: EntryListViewModel
    
    var body: some View {
        List {
            // iterate over everything in the entry list and make an entry view
            ForEach(viewModel.todaysEntries, id: \.self) { entry in
                EntryView(viewModel: entry)
                    .listRowInsets(EdgeInsets())
            }
            // Handles deleting the item
            .onDelete { indexSet in
                viewModel.deleteEntries(at: indexSet)
            }
        }
        .listStyle(PlainListStyle())
        .padding(.horizontal, 30)
        .padding(.bottom, 30)
    }
}

#Preview {
    EntryListView(viewModel: EntryListViewModel(dateViewModel: DateViewModel()))
}
