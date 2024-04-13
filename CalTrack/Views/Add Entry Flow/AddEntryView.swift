//
//  AddEntryView.swift
//  CalTrack-Refactored
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
    
    // This is used to close the popup
    @Binding var showingPopup: Bool
    
    // To pick whether it is food or activity entry
    @State private var selection: Selection = .food
    
    // This controls the display in the boxes
    @State private var entryText: String = ""
    @State private var kcalText: String = ""
    
    // This controls what to pass to the new entry
    @State private var entryName: String = ""
    @State private var kcalCount: String = ""
    
    // The function to add an entry to the entry list
    func addEntry() {
        if entryText.isEmpty {
            return
        }
        
        // Find information regarding the entry
        let consume = selection == .food
        let kcalCount = Int(kcalText) ?? 0
        
        // Create the entry and add it
        let newEntry = Entry(id: UUID(), 
                             name: entryText,
                             consume: consume,
                             kcalCount: kcalCount,
                             apple: false)
        
        dateManagerViewModel
            .selectedDayViewModel
            .addEntry(entry: newEntry)
        dateManagerViewModel.saveDate()
    }
    
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
            
            HStack{
                Spacer()
                
                // Where you enter the entry name
                TextField("Entry Name", text: $entryText)
                    .font(.title3)
                    .padding()
                    .onChange(of: entryText) { oldValue, newValue in
                        entryName = newValue
                    }
                    
               
                Spacer()
            }
            .border(AppColours.CalTrackStroke)
            .padding(.horizontal, 30)
            .padding(.top, 20)
            
            HStack{
                Spacer()
                
                // Where you enter the entry calorie count with number pad
                TextField("Calorie count", text: $kcalText)
                    .font(.title3)
                    .padding()
                    .keyboardType(.numberPad)
                    .onChange(of: kcalText) { oldValue, newValue in
                        kcalCount = newValue
                    }
                    
               
                Spacer()
            }
            .border(AppColours.CalTrackStroke)
            .padding(.horizontal, 30)
            .padding(.top, 20)
            
            HStack {
                // This calls the add entry and closes the sheet
                Button(action: {
                    showingPopup = false
                }) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .foregroundColor(.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(AppColours.CalTrackStroke, lineWidth: 2)
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.leading, 30)
                .padding(.top, 20)
                
                // This calls the add entry and closes the sheet
                Button(action: {
                    addEntry()
                    showingPopup = false
                }) {
                    Text("Confirm")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .foregroundColor(.black)
                .background(AppColours.CalTrackLightBlue)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.trailing, 30)
                .padding(.top, 20)
                
            }
        }
        .background(Color.white)
        .foregroundColor(.black)
        .ignoresSafeArea()
    }
}

#Preview {
    
    AddEntryView(dateManagerViewModel: DateManagerViewModel(dateManager: DateManager(startingDate: Date())), showingPopup: .constant(true))
}
