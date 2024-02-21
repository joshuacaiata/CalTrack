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
            //Make a yellow circle
            Circle()
                .stroke(lineWidth: 10)
                .foregroundColor(AppColors.CalTrackYellow)
            
            // Overlay a pink circle
            Circle()
                // make it go around the correct percent
                .trim(from: 0.0, to: CGFloat(min(max(viewModel.percentComplete, 0), 1)))
                .stroke(lineWidth: 10)
                .foregroundColor(AppColors.CalTrackPink)
                // rotate it
                .rotationEffect(Angle(degrees: 270))
                // make it have an animation on change
                .animation(.linear, value: CGFloat(min(max(viewModel.percentComplete, 0), 1)))
        }
    }
}

#Preview {
    ProgressBarView(viewModel: TrackerViewModel(entryList: EntryListViewModel()))
}
