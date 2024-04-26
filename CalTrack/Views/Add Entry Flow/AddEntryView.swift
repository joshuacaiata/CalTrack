//
//  AddEntryView.swift
//  CalTrack
//
//  Created by Joshua Caiata on 3/15/24.
//

import SwiftUI

// Contains the views for searching for foods, adding foods, and adding activity
struct AddEntryView: View {
    // Observe the entrylist view model to add entries
    @ObservedObject var dateManagerViewModel: DateManagerViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    enum Selection {
        case food, activity
    }
    
    @State private var selection: Selection = .food
    
    var body: some View {
        VStack {
            HStack {
                // Create "food" option button
                Button(action: {
                    selection = .food
                }) {
                    Text("Food")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .contentShape(Rectangle())
                }
                .foregroundColor(selection == .food ? .black : (colorScheme == .dark ? .white : .black))
                .background(selection == .food ? AppColours.CalTrackLightBlue : .clear)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(selection == .food ? AppColours.CalTrackLightBlue
                                : AppColours.CalTrackStroke, lineWidth: 2)
                )
                
                // Create "activity" option button
                Button(action : {
                    selection = .activity
                }) {
                    Text("Activity")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .contentShape(Rectangle())
                }
                .foregroundColor(selection == .activity ? .black : (colorScheme == .dark ? .white : .black))
                .background(selection == .activity ? AppColours.CalTrackLightBlue : .clear)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(selection == .activity ? AppColours.CalTrackLightBlue : AppColours.CalTrackStroke, lineWidth: 2)
                )
            }
            .padding(.horizontal, 30)
            .padding(.top)
            
            if selection == .food {
                SearchView(dateManagerViewModel: dateManagerViewModel)
            } else {
                AddActivity(dateManagerViewModel: dateManagerViewModel)
            }
        }
    }
}

#Preview {
    AddEntryView(dateManagerViewModel: DateManagerViewModel(dateManager: DateManager(startingDate: Date()), database: DatabaseManager()))
}
