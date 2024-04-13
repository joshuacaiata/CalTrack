//
//  UpdateTargetView.swift
//  CalTrack-Refactored
//
//  Created by Joshua Caiata on 3/15/24.
//

import SwiftUI

struct UpdateTargetView: View {
    @ObservedObject var dateManagerViewModel: DateManagerViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack{
                    // shows the progress bar circle
                    ProgressBarView(dayViewModel: dateManagerViewModel.selectedDayViewModel)
                        .frame(width: 200, height: 200)
                    // displays calorie count, checking if user is over their limit or not
                    VStack{
                        Text("\(dateManagerViewModel.selectedDayViewModel.dayModel.netCalories >= 0 ? dateManagerViewModel.selectedDayViewModel.dayModel.netCalories : -1 * dateManagerViewModel.selectedDayViewModel.dayModel.netCalories)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(dateManagerViewModel.selectedDayViewModel.dayModel.netCalories >= 0 ? "kcal remaining" : "over")
                    }
                }
                .padding(.vertical, 50)
                .padding(.horizontal, 70)
                .background(AppColours.CalTrackLightBlue)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.bottom, 50)
                
                Text("Set Daily Calorie Goal")
                    .font(.title3)
                                
                TextField("Target calories", text: $dateManagerViewModel.selectedDayViewModel.targetString)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.title3)
                    .frame(width: 250)
                    .multilineTextAlignment(.center)
                    .bold()
                
                Button(action: {
                    isPresented = false
                }) {
                    Text("Confirm")
                        .padding()
                        .padding(.horizontal, 30)
                }
                .foregroundColor(.black)
                .background(AppColours.CalTrackLightBlue)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal, 10)
                .padding(.top, 20)
                
                Spacer()
            }
            .padding(.top, 75)
        }
    }
}

#Preview {
    UpdateTargetView(dateManagerViewModel: DateManagerViewModel(dateManager: DateManager(startingDate: Date())), isPresented: .constant(true))
}
