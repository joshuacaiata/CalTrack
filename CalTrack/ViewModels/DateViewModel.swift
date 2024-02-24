//
//  DateViewModel.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/22/24.
//

import Foundation

class DateViewModel: ObservableObject {
    @Published var selectedDate = Date()
    
    // Increase the selected date by 1
    func goToNextDay() {
        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
    }
    
    // Decrease the selected date by 1
    func goToPreviousDay() {
        selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!
    }
    
    // formats the current date
    var formattedCurrentDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM dd"
        return dateFormatter.string(from: selectedDate)
    }
}
