//
//  SummaryView.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/18/24.
//

import SwiftUI

struct SummaryView: View {
    @ObservedObject var viewModel: TrackerViewModel
    
    var formattedCurrentDate: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
            return dateFormatter.string(from: Date())
        }
    
    var body: some View {
        HStack {
            Spacer()
            VStack{
                Text("\(formattedCurrentDate)")
                    .padding(.all, 10)
                ZStack{
                    ProgressBarView(viewModel: TrackerViewModel())
                        .frame(width: 200, height: 200)
                    VStack{
                        Text("\(viewModel.net)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("kcal remaining")
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
    SummaryView(viewModel: TrackerViewModel())
}
