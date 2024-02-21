//
//  EntryList.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/16/24.
//

import SwiftUI

struct EntryListView: View {
    @ObservedObject var viewModel: EntryListViewModel
    
    private func deleteItems(at offsets: IndexSet) {
        viewModel.deleteEntries(at: offsets)
    }
    
    var body: some View {
        List {
            // iterate over everything in the entry list and make an entry view
            ForEach(viewModel.entries, id: \.self) { entry in
                EntryView(viewModel: entry)
                    .listRowInsets(EdgeInsets())
            }
            // Handles deleting the item
            .onDelete(perform: deleteItems)
        }
        .listStyle(PlainListStyle())
        .padding(.horizontal, 30)
        .padding(.bottom, 30)
    }
}

#Preview {
    EntryListView(viewModel: EntryListViewModel())
}
