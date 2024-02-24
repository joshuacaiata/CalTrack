//
//  UpdateTargetView.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/23/24.
//

import SwiftUI

struct UpdateTargetView: View {
    @ObservedObject var trackerViewModel: TrackerViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Current Target:")
                        .font(.title3)
                        
                    Spacer()
                    
                    Text("\(trackerViewModel.target)")
                        .font(.title3)
                }
                .padding(.horizontal, 30)
                
                HStack {
                    Text("Current Net:")
                        .font(.title3)
                        
                    Spacer()
                    
                    Text("\(trackerViewModel.net >= 0 ? trackerViewModel.net : -1 * trackerViewModel.net)")
                        .font(.title3)
                }
                .padding(.horizontal, 30)
                
                HStack{
                    Text("Set Daily Calorie Goal")
                        .font(.title3)
                    
                    Spacer()
                    
                    TextField("Target calories", value: $trackerViewModel.target, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.title3)
                        .frame(width:100)
                        .multilineTextAlignment(.trailing)
                        .bold()
                        
                }
                .padding(.horizontal, 30)
                .padding(.top, 50)
                
                
                Button(action: {
                    isPresented = false
                }) {
                    Text("Confirm")
                        .padding()
                        .padding(.horizontal, 30)
                }
                .foregroundColor(.black)
                .background(AppColors.CalTrackLightBlue)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal, 10)
                .padding(.top, 20)
                
                Spacer()
            }
            .padding(.top, 200)
        }
    }
}

#Preview {
    UpdateTargetView(trackerViewModel: TrackerViewModel(entryList: EntryListViewModel(dateViewModel: DateViewModel())), isPresented: .constant(true))
}
