//
//  ProgressBarView.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/14/24.
//

import SwiftUI

struct ProgressBarView: View {
    @ObservedObject var viewModel: TrackerViewModel
    
    var body: some View {
        // Background Circle
        ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .foregroundColor(AppColors.CalTrackYellow)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(max(viewModel.percentComplete, 0), 1)))
                .stroke(lineWidth: 10)
                .foregroundColor(AppColors.CalTrackPink)
                .rotationEffect(Angle(degrees: 270))
                .animation(.linear, value: CGFloat(min(max(viewModel.percentComplete, 0), 1)))
        }
    }
}

#Preview {
    ProgressBarView(viewModel: TrackerViewModel())
}
