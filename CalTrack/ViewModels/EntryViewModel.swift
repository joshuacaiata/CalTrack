//
//  EntryViewModel.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/16/24.
//

import Foundation
import SwiftUI

class EntryViewModel: ObservableObject {
    @Published var info: Entry
    
    var name: String {
        info.name
    }
    
    var consume: Bool {
        info.consume
    }
    var kcalCount: Int {
        info.kcalCount
    }
    
    var calColor: Color {
            consume ? AppColors.CalTrackNegative : AppColors.CalTrackPositive
    }
    
    init(name: String, consume: Bool, kcalCount: Int) {
        self.info = Entry(name: name, consume: consume, kcalCount: kcalCount)
    }
}
