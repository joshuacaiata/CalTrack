//
//  SummaryView.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/18/24.
//

import SwiftUI

struct SummaryView: View {
    @ObservedObject var trackerViewModel: TrackerViewModel
    @State private var showingUpdateTarget = false
    
    var body: some View {
        HStack {
            Spacer()
            VStack{
                
                HStack {
                           
                    Spacer()
                    
                    Button(action: {
                        trackerViewModel.entryList.dateViewModel.goToPreviousDay()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .padding(.leading)
                    }
                    
                    // shows the date
                    Text("\(trackerViewModel.entryList.dateViewModel.formattedCurrentDate)")
                        .font(.title3)
                        .padding(.all, 10)
                        .frame(minWidth: 200)
                    
                    Button(action: {
                        trackerViewModel.entryList.dateViewModel.goToNextDay()
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
                .onTapGesture {
                    showingUpdateTarget = true
                }
            }
            .padding(.vertical, 25)
            .frame(maxWidth:.infinity)
            Spacer()
        }
        .background(AppColors.CalTrackLightBlue)
        .foregroundColor(.black)
        .cornerRadius(15)
        .padding(.top, 25)
        .padding(.horizontal, 30)
        .padding(.bottom, 30)
        .sheet(isPresented: $showingUpdateTarget, content: {
            UpdateTargetView(trackerViewModel: trackerViewModel, isPresented: $showingUpdateTarget)
                .preferredColorScheme(.light)
        })
    }
}

#Preview {
    SummaryView(trackerViewModel: TrackerViewModel(entryList: EntryListViewModel(dateViewModel: DateViewModel())))
}
