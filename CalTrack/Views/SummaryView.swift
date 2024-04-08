//
//  SummaryView.swift
//  CalTrack-Refactored
//
//  Created by Joshua Caiata on 3/15/24.
//

import SwiftUI


struct SummaryView: View {
    @ObservedObject var dateManagerViewModel: DateManagerViewModel
    @State private var showingUpdateTarget = false
    
    var body: some View {
        HStack {
            Spacer()
            VStack{
                
                HStack {
                           
                    Spacer()
                    
                    Button(action: {
                        dateManagerViewModel.goToPreviousDay()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .padding(.leading)
                    }
                    
                    // shows the date
                    Text("\(dateManagerViewModel.selectedDayViewModel.info.formattedCurrentDate)")
                        .font(.title3)
                        .padding(.all, 10)
                        .frame(minWidth: 200)
                    
                    Button(action: {
                        dateManagerViewModel.goToNextDay()
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .padding(.trailing)
                    }
                    
                    Spacer()
                    
                }
                
                ZStack{
                    // shows the progress bar circle
                    ProgressBarView(dayViewModel: dateManagerViewModel.selectedDayViewModel)
                        .frame(width: 200, height: 200)
                    // displays calorie count, checking if user is over their limit or not
                    VStack{
                        Text("\(dateManagerViewModel.selectedDayViewModel.info.netCalories >= 0 ? dateManagerViewModel.selectedDayViewModel.info.netCalories : -1 * dateManagerViewModel.selectedDayViewModel.info.netCalories)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(dateManagerViewModel.selectedDayViewModel.info.netCalories >= 0 ? "kcal remaining" : "over")
                    }
                }
                .onTapGesture {
                    showingUpdateTarget = true
                }
            }
            .padding(.vertical, 25)
            .frame(maxWidth:.infinity)
            Spacer()
        }
        .background(AppColours.CalTrackLightBlue)
        .foregroundColor(.black)
        .cornerRadius(15)
        .padding(.top, 25)
        .padding(.horizontal, 30)
        .padding(.bottom, 30)
        .sheet(isPresented: $showingUpdateTarget, content: {
            UpdateTargetView(dateManagerViewModel: dateManagerViewModel, isPresented: $showingUpdateTarget)
                .preferredColorScheme(.light)
        })
    }
}
#Preview {
    SummaryView(dateManagerViewModel: DateManagerViewModel(dateManager: DateManager(startingDate: Date())))
}


