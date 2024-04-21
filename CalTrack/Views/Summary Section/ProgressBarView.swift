//
//  ProgressBarView.swift
//  CalTrack-Refactored
//
//  Created by Joshua Caiata on 3/15/24.
//

import SwiftUI

// View for the progress bar
struct ProgressBarView: View {
    @ObservedObject var dayViewModel: DayViewModel
    
    init(dayViewModel: DayViewModel) {
        self.dayViewModel = dayViewModel
    }
    
    var body: some View {
        // Background Circle
        ZStack {
            //Make a yellow circle
            Circle()
                .stroke(lineWidth: 10)
                .foregroundColor(AppColours.CalTrackYellow)
            
            // Overlay a pink circle
            Circle()
                // make it go around the correct percent
                .trim(from: 0.0, to: CGFloat(min(max(dayViewModel.dayModel.percentComplete, 0), 1)))
                .stroke(lineWidth: 10)
                .foregroundColor(AppColours.CalTrackPink)
                // rotate it
                .rotationEffect(Angle(degrees: 270))
                // make it have an animation on change
                .animation(.linear, value: CGFloat(min(max(dayViewModel.dayModel.percentComplete, 0), 1)))
        }
    }
}

#Preview {
    ProgressBarView(dayViewModel: DayViewModel(day: Day(date: Date())))
}
