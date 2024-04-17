//
//  AddEntryView.swift
//  CalTrack
//
//  Created by Joshua Caiata on 3/15/24.
//

import SwiftUI

struct AddEntryView: View {
    // Observe the entrylist view model to add entries
    @ObservedObject var dateManagerViewModel: DateManagerViewModel
    
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
                .foregroundColor(.black)
                .background(selection == .food ? AppColours.CalTrackLightBlue : Color.white)
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
                .foregroundColor(.black)
                .background(selection == .activity ? AppColours.CalTrackLightBlue : Color.white)
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
    AddEntryView(dateManagerViewModel: DateManagerViewModel(dateManager: DateManager(startingDate: Date())))
}
