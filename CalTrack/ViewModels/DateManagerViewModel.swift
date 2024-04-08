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
        
        selectedDayViewModel.$info
            .sink { [weak self] _ in
                self?.objectWillChange.send()
                self?.saveDate()
            }
            .store(in: &cancellables)
    }
    
    func goToNextDay() {
        let newDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        setDay(to: newDate)
    }
    
    func goToPreviousDay() {
        let newDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        setDay(to: newDate)
    }
    
    func setDay(to date: Date) -> Void {
        self.info.currentDate = date
        self.info.selectedDay = info.loadDay(date: date)
        self.selectedDayViewModel = DayViewModel(day: self.info.selectedDay)
    }
    
    func saveDate() {
        let normalizedDate = DateManager.normalizeDate(info.currentDate)
        info.dates[normalizedDate] = selectedDayViewModel.info
        info.selectedDay = selectedDayViewModel.info
        PersistenceManager.shared.saveDateManager(dateManager: info)
    }
}
