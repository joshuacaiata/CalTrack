//
//  DateManagerViewModel.swift
//  CalTrack-Refactored
//
//  Created by Joshua Caiata on 3/14/24.
//

import Foundation
import Combine

// ViewModel for the DateManager model
class DateManagerViewModel: ObservableObject {
    @Published var dateManagerModel: DateManager
    @Published var selectedDayViewModel: DayViewModel
    
    var currentDate: Date { dateManagerModel.currentDate }
    
    var database: DatabaseManager
            
    init(dateManager: DateManager, database: DatabaseManager) {
        self.dateManagerModel = dateManager
        self.selectedDayViewModel = DayViewModel(day: dateManager.selectedDay, database: database)
        self.database = database
    }
    
    // Functionality for when user clicks next day
    func goToNextDay() {
        let newDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        setDay(to: newDate)
    }
    
    // Functionality for when user clicks prev day
    func goToPreviousDay() {
        let newDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        setDay(to: newDate)
    }
    
    // Saves the date to memory and in the DateManager
    func saveDate() {
        let normalizedDate = DateManager.normalizeDate(dateManagerModel.currentDate)
        dateManagerModel.dates[normalizedDate] = selectedDayViewModel.dayModel
        dateManagerModel.selectedDay = selectedDayViewModel.dayModel
        PersistenceManager.shared.saveDateManager(dateManager: dateManagerModel)
    }
    
    // Set the day to the given day passed into the function
    func setDay(to date: Date) -> Void {
        // Set the model's current date to the new date
        self.dateManagerModel.currentDate = date
        
        // Load the day at the new date
        let newDay = dateManagerModel.loadDay(date: date)
        
        // Set the selectedDay to the day loaded in the previous step
        self.dateManagerModel.selectedDay = newDay
        
        // Create a new DayViewModel for the selected day
        let newDayViewModel = DayViewModel(day: newDay, database: self.database)
        
        // Update the published selectedDayViewModel to trigger UI updates
        self.selectedDayViewModel = newDayViewModel
        
        // Configure calorie tracking with healthkit using Task due to asynchronous nature of configureHealthKitManager
        Task { @MainActor in
            // Get total active calories from HealthKit
            let totalActiveCalories = await configureHealthKitManager()
            
            // Get the total active calories and set the selected day view model
            let updatedInfo = self.selectedDayViewModel
            updatedInfo.dayModel.totalHealthKitActiveCalories = totalActiveCalories
            self.selectedDayViewModel = updatedInfo
        }
        
    }
    
    // Get total active calories using HealthKit
    func configureHealthKitManager() async -> Int {
        var totalActiveCalories: Int = 0
        
        totalActiveCalories = await self.selectedDayViewModel.healthKitManager?.fetchTotalActiveCalories(for: selectedDayViewModel.dayModel.date) ?? 0
        
        return totalActiveCalories
    }
}
