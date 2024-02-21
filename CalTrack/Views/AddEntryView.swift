//
//  AddEntryView.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/18/24.
//

import SwiftUI

struct AddEntryView: View {
    // Observe the entrylist view model to add entries
    @ObservedObject var viewModel: EntryListViewModel
    
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
        // Find information regarding the entry
        let consume = selection == .food
        let kcalCount = Int(kcalText) ?? 0
        
        // Create the entry and add it
        let newEntry = Entry(name: entryText, consume: consume, kcalCount: kcalCount)
        let newEntryViewModel = EntryViewModel(name: newEntry.name, consume: newEntry.consume, kcalCount: newEntry.kcalCount)
        
        viewModel.addEntry(entry: newEntryViewModel)
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
                .background(selection == .food ? AppColors.CalTrackLightBlue : Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(selection == .food ? AppColors.CalTrackLightBlue : AppColors.CalTrackStroke, lineWidth: 2)
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
                .background(selection == .activity ? AppColors.CalTrackLightBlue : Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(selection == .activity ? AppColors.CalTrackLightBlue : AppColors.CalTrackStroke, lineWidth: 2)
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
            .border(AppColors.CalTrackStroke)
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
            .border(AppColors.CalTrackStroke)
            .padding(.horizontal, 30)
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
            .background(AppColors.CalTrackLightBlue)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 30)
            .padding(.top, 20)
            
            
        }
    }
}

#Preview {
    AddEntryView(viewModel: EntryListViewModel(), showingPopup: .constant(true))
}
