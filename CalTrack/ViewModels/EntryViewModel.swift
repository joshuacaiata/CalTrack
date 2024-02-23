//
//  EntryViewModel.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/16/24.
//

import Foundation
import SwiftUI

// This is hashable for the entrylistview so we can use ForEach
class EntryViewModel: ObservableObject, Hashable, Identifiable {
    @Published var info: Entry
    
    // Properties of Entry
    var name: String { info.name }
    var consume: Bool { info.consume }
    var kcalCount: Int { info.kcalCount }
    var date: Date { info.date }
    var id: UUID { info.id }
    
    // Which colour do we use for the text
    var calColor: Color {
            consume ? AppColors.CalTrackNegative : AppColors.CalTrackPositive
    }
    
    // Initializer
    init(id: UUID, name: String, consume: Bool, kcalCount: Int, date: Date) {
        self.info = Entry(id: id, name: name, consume: consume, kcalCount: kcalCount, date: date)
    }
    
    
    // == overload
    static func == (lhs: EntryViewModel, rhs: EntryViewModel) -> Bool {
        lhs.info == rhs.info
    }
    
    // hashing function
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
