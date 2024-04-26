//
//  EntryView.swift
//  CalTrack-Refactored
//
//  Created by Joshua Caiata on 3/15/24.
//

import SwiftUI

// The view for a single entry
struct EntryView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var entry: Entry
    
    var entryColour: Color {
        if ((colorScheme == .dark) && (entry.consume)) {
            AppColours.CalTrackNegativeDark
        } else if (entry.consume) {
            AppColours.CalTrackNegative
        } else {
            AppColours.CalTrackPositive
        }
    }
            
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
            .foregroundColor(entryColour)
            .padding(.horizontal, 10)
        }
        .padding(.vertical, 20)
    }
}

#Preview {
    EntryView(entry: Entry(id: UUID(), name: "Apple Strudle, Baked, with cheese and ham", date: Date(), consume: true, kcalCount: 100, apple: false))
}
