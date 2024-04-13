//
//  EntryView.swift
//  CalTrack-Refactored
//
//  Created by Joshua Caiata on 3/15/24.
//

import SwiftUI

struct EntryView: View {

    var entry: Entry
            
    // Creates and styles each entry
    var body: some View {
        HStack{
            Text("\(entry.name)")
                .font(.title3)
            Spacer()
            HStack {
                Text(entry.consume ? "-\(entry.kcalCount)" : "+\(entry.kcalCount)")
                    .font(.title3)
                    .fontWeight(.bold)
                Text("kcal")
                    .font(.body)
            }
            .foregroundColor(entry.calColor)
            .padding(.vertical, 20.0)
            .padding(.horizontal, 10)
        }
        .background(Color.white)
        .foregroundColor(.black)
    }
}

#Preview {
    EntryView(entry: Entry(id: UUID(), name: "Apple", consume: true, kcalCount: 100, apple: false))
}