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
                ZStack{
                    // shows the progress bar circle
                    ProgressBarView(viewModel: trackerViewModel)
                        .frame(width: 200, height: 200)
                    // displays calorie count, checking if user is over their limit or not
                    VStack{
                        Text("\(trackerViewModel.net >= 0 ? trackerViewModel.net : -1 * trackerViewModel.net)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(trackerViewModel.net >= 0 ? "kcal remaining" : "over")
                    }
                }
                .padding(.vertical, 50)
                .padding(.horizontal, 70)
                .background(AppColors.CalTrackLightBlue)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.bottom, 50)
                
                Text("Set Daily Calorie Goal")
                    .font(.title3)
                                
                TextField("Target calories", text: $trackerViewModel.targetString)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.title3)
                    .frame(width: 250)
                    .multilineTextAlignment(.center)
                    .bold()
                    .onAppear {
                        trackerViewModel.targetString = "\(trackerViewModel.target)"
                    }
                    .onChange(of: trackerViewModel.targetString) {
                        trackerViewModel.updateTargetFromString()
                    }
                
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
            .padding(.top, 75)
        }
    }
}

#Preview {
    UpdateTargetView(trackerViewModel: TrackerViewModel(entryList: EntryListViewModel(dateViewModel: DateViewModel())), isPresented: .constant(true))
}
