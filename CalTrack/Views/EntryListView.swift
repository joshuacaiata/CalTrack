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
            ForEach(viewModel.entries, id: \.self) { entry in
                EntryView(viewModel: entry)
                    .background(Color.white)
                    .listRowInsets(EdgeInsets())
            }
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
