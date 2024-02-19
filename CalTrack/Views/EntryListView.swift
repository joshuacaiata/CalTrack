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
        ScrollView{
            VStack{
                ForEach(viewModel.entries, id: \.self) { entry in
                    EntryView(viewModel: entry)
                }
            }
        }
        .padding(.bottom, 30)
    }
}

#Preview {
    EntryListView(viewModel: EntryListViewModel())
}
