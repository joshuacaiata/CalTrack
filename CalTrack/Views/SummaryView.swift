//
//  SummaryView.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/18/24.
//

import SwiftUI

struct SummaryView: View {
    @ObservedObject var viewModel: TrackerViewModel
    
    // formats the current date
    var formattedCurrentDate: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
            return dateFormatter.string(from: Date())
        }
    
    var body: some View {
        HStack {
            Spacer()
            VStack{
                // shows the date
                Text("\(formattedCurrentDate)")
                    .padding(.all, 10)
                ZStack{
                    // shows the progress bar circle
                    ProgressBarView(viewModel: viewModel)
                        .frame(width: 200, height: 200)
                    // displays calorie count, checking if user is over their limit or not
                    VStack{
                        Text("\(viewModel.net >= 0 ? viewModel.net : -1 * viewModel.net)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(viewModel.net >= 0 ? "kcal remaining" : "over")
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
    SummaryView(viewModel: TrackerViewModel(entryList: EntryListViewModel()))
}
