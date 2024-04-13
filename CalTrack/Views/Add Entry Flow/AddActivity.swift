//
//  AddActivity.swift
//  CalTrack
//
//  Created by Joshua Caiata on 4/11/24.
//

import SwiftUI

struct AddActivity: View {
    // This controls the display in the boxes
    @State private var entryText: String = ""
    @State private var kcalText: String = ""
    
    // This controls what to pass to the new entry
    @State private var entryName: String = ""
    @State private var kcalCount: String = ""
    
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
    AddActivity()
}
