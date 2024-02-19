//
//  Entry.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/16/24.
//

import SwiftUI

struct EntryView: View {
    @ObservedObject var viewModel: EntryViewModel
        
    
    var body: some View {
        HStack{
            Text("\(viewModel.name)")
                .font(.title3)
                .padding(.vertical, 10.0)
                .padding(.leading, 25)
            Spacer()
            HStack {
                Text("-\(viewModel.kcalCount)")
                    .font(.title3)
                    .fontWeight(.bold)
                Text("kcal")
                    .font(.body)
                    .padding(.trailing, 25)
            }
            .foregroundColor(viewModel.calColor)
        }
        .border(AppColors.CalTrackStroke, width: 2)
        .cornerRadius(4)
        .padding(.horizontal, 30.0)
    }
}

#Preview {
    EntryView(viewModel: EntryViewModel(name: "Apple", consume: true, kcalCount: 100))
}
