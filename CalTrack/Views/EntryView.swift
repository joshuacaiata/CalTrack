//
//  Entry.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/16/24.
//

import SwiftUI

struct EntryView: View {
    @ObservedObject var viewModel: EntryViewModel
        
    // Creates and styles each entry
    var body: some View {
        HStack{
            Text("\(viewModel.name)")
                .font(.title3)
            Spacer()
            HStack {
                Text(viewModel.consume ? "-\(viewModel.kcalCount)" : "+\(viewModel.kcalCount)")
                    .font(.title3)
                    .fontWeight(.bold)
                Text("kcal")
                    .font(.body)
            }
            .foregroundColor(viewModel.calColor)
            .padding(.vertical, 20.0)
            .padding(.horizontal, 10)
        }
    }
}

#Preview {
    EntryView(viewModel: EntryViewModel(name: "Apple", consume: true, kcalCount: 100, date: Date()))
}
