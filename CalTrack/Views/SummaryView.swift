//
//  SummaryView.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/18/24.
//

import SwiftUI

struct SummaryView: View {
    @ObservedObject var trackerViewModel: TrackerViewModel
    @ObservedObject var dateViewModel: DateViewModel
    
    var body: some View {
        HStack {
            Spacer()
            VStack{
                // shows the date
                Text("\(dateViewModel.formattedCurrentDate)")
                    .padding(.all, 10)
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
            }
            .padding(.vertical, 25)
            .frame(maxWidth:.infinity)
            Spacer()
        }
        .background(AppColors.CalTrackLightBlue)
        .cornerRadius(15)
        .padding(.top, 25)
        .padding(.horizontal, 30)
        .padding(.bottom, 30)
    }
}

#Preview {
    SummaryView(trackerViewModel: TrackerViewModel(entryList: EntryListViewModel(dateViewModel: DateViewModel())), dateViewModel: DateViewModel())
}
