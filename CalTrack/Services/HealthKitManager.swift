//
//  HealthKitManager.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/28/24.
//

import Foundation
import HealthKit
import SwiftUI

class HealthKitManager {
    @ObservedObject var viewModel: TrackerViewModel
    
    let healthStore = HKHealthStore()
    
    init(viewModel: TrackerViewModel) {
        self.viewModel = viewModel
    }
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            return
        }
        
        let types: Set = [
            HKQuantityType.workoutType(),
            HKQuantityType(.activeEnergyBurned)
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: types) { (success, error) in
            if !success {
                return
            }
        }
    }
    
    func fetchWorkouts(completion: @escaping ([HKWorkout]?) -> Void) {
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: .workoutType(), predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            
            DispatchQueue.main.async {
               
                guard let workouts = samples as? [HKWorkout], error == nil else {
                    completion(nil)
                    return
                }
                
                completion(workouts)
            }
        }
        
        healthStore.execute(query)
    }
    
    func addWorkoutEntries(workouts: [HKWorkout]) {
        for workout in workouts {
            let calories = workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0
            
            let workoutName = workoutTypetoName(workout.workoutActivityType)
            
            let workoutEntry = Entry(name: workoutName, consume: false, kcalCount: Int(calories), date: workout.startDate)
            let workoutEntryVM = EntryViewModel(id: workoutEntry.id, name: workoutEntry.name, consume: workoutEntry.consume, kcalCount: workoutEntry.kcalCount, date: workoutEntry.date)
            
            self.viewModel.entryList.addEntry(entry: workoutEntryVM)
        }
    }
    
    private func workoutTypetoName(_ workoutType: HKWorkoutActivityType) -> String {
        switch workoutType {
        case .archery: return "Archery"
        case .bowling: return "Bowling"
        case .fencing: return "Fencing"
        case .gymnastics: return "Gymnastics"
        case .trackAndField: return "Track and Field"
        case .americanFootball: return "American Football"
        case .australianFootball: return "Australian Football"
        case .baseball: return "Baseball"
        case .basketball: return "Basketball"
        case .cricket: return "Cricket"
        case .discSports: return "Disc Sport"
        case .handball: return "Handball"
        case .hockey: return "Hockey"
        case .lacrosse: return "Lacrosse"
        case .rugby: return "Rugby"
        case .soccer: return "Soccer"
        case .softball: return "Softball"
        case .volleyball: return "Volleyball"
        case .preparationAndRecovery: return "Prep & Recovery"
        case .flexibility: return "Flexibility"
        case .cooldown: return "Cooldown"
        case .walking: return "Walking"
        case .running: return "Running"
        case .wheelchairWalkPace: return "Wheelchair Walk"
        case .wheelchairRunPace: return "Wheelchair Run"
        case .cycling: return "Cycling"
        case .badminton: return "Badminton"
        case .barre: return "Barre"
        case .boxing: return "Boxing" // Traditional boxing
        case .climbing: return "Climbing"
        case .crossCountrySkiing: return "Cross Country Skiing"
        case .crossTraining: return "Cross Training" // Any workout that doesn't fit another category
        case .curling: return "Curling"
        case .dance: return "Dance"
        case .danceInspiredTraining: return "Dance Inspired Training"
        case .elliptical: return "Elliptical"
        case .equestrianSports: return "Equestrian Sports" // Horseback riding
        case .fishing: return "Fishing"
        case .functionalStrengthTraining: return "Functional Strength Training"
        case .golf: return "Golf"
        case .handCycling: return "Hand Cycling"
        case .highIntensityIntervalTraining: return "High Intensity Interval Training"
        case .hiking: return "Hiking"
        case .hunting: return "Hunting"
        case .martialArts: return "Martial Arts"
        case .mindAndBody: return "Mind and Body" // Yoga, meditation, etc.
        case .mixedCardio: return "Mixed Cardio" // Various cardio exercises
        case .paddleSports: return "Paddle Sports"
        case .play: return "Play" // General playing, active recreation
        case .racquetball: return "Racquetball"
        case .rowing: return "Rowing"
        case .sailing: return "Sailing"
        case .skatingSports: return "Skating Sports"
        case .snowSports: return "Snow Sports"
        case .squash: return "Squash"
        case .stairClimbing: return "Stair Climbing" // Includes stair machines
        case .surfingSports: return "Surfing Sports"
        case .swimming: return "Swimming"
        case .tableTennis: return "Table Tennis"
        case .tennis: return "Tennis"
        case .waterFitness: return "Water Fitness"
        case .waterPolo: return "Water Polo"
        case .waterSports: return "Water Sports"
        case .wrestling: return "Wrestling"
        case .yoga: return "Yoga"
        default: return "Apple Workout"
        }
    }
}
