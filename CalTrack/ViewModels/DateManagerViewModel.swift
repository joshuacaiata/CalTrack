//
//  DateManagerViewModel.swift
//  CalTrack-Refactored
//
//  Created by Joshua Caiata on 3/14/24.
//

import Foundation
import Combine

class DateManagerViewModel: ObservableObject {
    @Published var dateManagerModel: DateManager
    @Published var selectedDayViewModel: DayViewModel
    
    var currentDate: Date { dateManagerModel.currentDate }
    
    private var cancellables = Set<AnyCancellable>()
        
    init(dateManager: DateManager) {
        self.dateManagerModel = dateManager
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
        let normalizedDate = DateManager.normalizeDate(dateManagerModel.currentDate)
        dateManagerModel.dates[normalizedDate] = selectedDayViewModel.dayModel
        dateManagerModel.selectedDay = selectedDayViewModel.dayModel
        PersistenceManager.shared.saveDateManager(dateManager: dateManagerModel)
    }
    
    func setDay(to date: Date) -> Void {
        self.dateManagerModel.currentDate = date
        let newDay = dateManagerModel.loadDay(date: date)
        self.dateManagerModel.selectedDay = newDay
        
        // Create a new DayViewModel for the selected day
        let newDayViewModel = DayViewModel(day: newDay)
        
        // Update the published selectedDayViewModel to trigger UI updates
        self.selectedDayViewModel = newDayViewModel
        Task { @MainActor in
            let totalActiveCalories = await self.selectedDayViewModel.configureHealthKitManager()
            
            let updatedInfo = self.selectedDayViewModel
            updatedInfo.dayModel.totalHealthKitActiveCalories = totalActiveCalories
            self.selectedDayViewModel = updatedInfo
        }
        
    }
}
