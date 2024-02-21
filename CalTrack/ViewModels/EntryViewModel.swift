//
//  EntryViewModel.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/16/24.
//

import Foundation
import SwiftUI

// This is hashable for the entrylistview so we can use ForEach
class EntryViewModel: ObservableObject, Hashable {
    @Published var info: Entry
    
    // Name of entry
    var name: String {
        info.name
    }
    
    // Whether its consuming or activity
    var consume: Bool {
        info.consume
    }
    
    // Calorie count
    var kcalCount: Int {
        info.kcalCount
    }
    
    // Which colour do we use for the text
    var calColor: Color {
            consume ? AppColors.CalTrackNegative : AppColors.CalTrackPositive
    }
    
    // Initializer
    init(name: String, consume: Bool, kcalCount: Int) {
            self.info = Entry(name: name, consume: consume, kcalCount: kcalCount)
    }
    
    
    // == overload
    static func == (lhs: EntryViewModel, rhs: EntryViewModel) -> Bool {
        lhs.info == rhs.info
    }
    
    // hashing function
    func hash(into hasher: inout Hasher) {
        hasher.combine(info)
    }
}
