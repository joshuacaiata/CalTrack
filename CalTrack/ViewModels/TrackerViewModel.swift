//
//  TrackerViewModel.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/13/24.
//

import Foundation

class TrackerViewModel: ObservableObject {
    @Published var info = Tracker()
    
    var consumedCalories: Int {
        info.consumedCalories
    }
    
    var burnedCalories: Int {
        info.burnedCalories
    }
    
    var net: Int {
        info.net
    }
}
