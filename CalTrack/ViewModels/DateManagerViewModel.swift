//
//  DateManagerViewModel.swift
//  CalTrack-Refactored
//
//  Created by Joshua Caiata on 3/14/24.
//

import Foundation
import Combine

class DateManagerViewModel: ObservableObject {
    @Published var info: DateManager
    @Published var selectedDayViewModel: DayViewModel
    
    var currentDate: Date { info.currentDate }
    
    private var cancellables = Set<AnyCancellable>()
        
    init(dateManager: DateManager) {
        self.info = dateManager
        self.selectedDayViewModel = DayViewModel(day: dateManager.selectedDay)
    }
    
    func goToNextDay() {
        let newDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        setDay(to: newDate)
    }
    
    func goToPreviousDay() {
        let newDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        setDay(to: newDate)
    }
    
    func saveDate() {
        let normalizedDate = DateManager.normalizeDate(info.currentDate)
        info.dates[normalizedDate] = selectedDayViewModel.info
        info.selectedDay = selectedDayViewModel.info
        PersistenceManager.shared.saveDateManager(dateManager: info)
    }
    
    func setDay(to date: Date) -> Void {
        self.info.currentDate = date
        let newDay = info.loadDay(date: date)
        self.info.selectedDay = newDay
        
        // Create a new DayViewModel for the selected day
        let newDayViewModel = DayViewModel(day: newDay)
        
        // Update the published selectedDayViewModel to trigger UI updates
        self.selectedDayViewModel = newDayViewModel
        Task { @MainActor in
            let totalActiveCalories = await self.selectedDayViewModel.configureHealthKitManager()
            
            let updatedInfo = self.selectedDayViewModel
            updatedInfo.info.totalHealthKitActiveCalories = totalActiveCalories
            self.selectedDayViewModel = updatedInfo
        }
        
    }
}
