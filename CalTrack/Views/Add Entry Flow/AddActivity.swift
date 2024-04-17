//
//  AddActivity.swift
//  CalTrack
//
//  Created by Joshua Caiata on 4/11/24.
//

import SwiftUI

struct AddActivity: View {
    @ObservedObject var dateManagerViewModel: DateManagerViewModel
    
    @Environment(\.dismiss) var dismiss
    
    // This controls the display in the boxes
    @State private var entryText: String = ""
    @State private var kcalText: String = ""
    
    // This controls what to pass to the new entry
    @State private var entryName: String = ""
    @State private var kcalCount: String = ""
    
    init(dateManagerViewModel: DateManagerViewModel) {
        self.dateManagerViewModel = dateManagerViewModel
    }
    
     func addEntry() {
         if entryText.isEmpty {
             return
         }
         
         // Find information regarding the entry
         let kcalCount = Int(kcalText) ?? 0
         
         // Create the entry and add it
         let newEntry = Entry(id: UUID(),
                              name: entryText,
                              consume: false,
                              kcalCount: kcalCount,
                              apple: false)
         
         dateManagerViewModel
             .selectedDayViewModel
             .addEntry(entry: newEntry)
         dateManagerViewModel.saveDate()
         dismiss()
     }
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                
                // Where you enter the entry name
                TextField("Workout Name", text: $entryText)
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
            
            Spacer()
            
            
            Button(action: {
                addEntry()
            }) {
                Text("Confirm")
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .foregroundColor(.black)
            .background(AppColours.CalTrackLightBlue)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 30)
            .padding(.top, 20)
            .padding(.bottom)
        }
        
    }
}

#Preview {
    AddActivity(dateManagerViewModel: DateManagerViewModel(dateManager: DateManager(startingDate: Date())))
}
