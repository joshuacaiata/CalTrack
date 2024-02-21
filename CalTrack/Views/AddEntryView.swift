//
//  AddEntryView.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/18/24.
//

import SwiftUI

struct AddEntryView: View {
    @ObservedObject var viewModel: EntryListViewModel
    
    enum Selection {
        case food, activity
    }
    
    @Binding var showingPopup: Bool
    
    @State private var selection: Selection = .food
    
    @State private var entryText: String = ""
    @State private var kcalText: String = ""
    
    @State private var entryName: String = ""
    @State private var kcalCount: String = ""
    
    func addEntry() {
        let consume = selection == .food
        let kcalCount = Int(kcalText) ?? 0
        
        let newEntry = Entry(name: entryText, consume: consume, kcalCount: kcalCount)
        let newEntryViewModel = EntryViewModel(name: newEntry.name, consume: newEntry.consume, kcalCount: newEntry.kcalCount)
        
        viewModel.addEntry(entry: newEntryViewModel)
    }
    
    var body: some View {
        VStack {
            HStack {
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
