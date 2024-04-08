//
//  HealthKitManager.swift
//  CalTrack-Refactored
//
//  Created by Joshua Caiata on 3/15/24.
//

import Foundation
import HealthKit
import SwiftUI

class HealthKitManager {
    var info: DayViewModel
    
    let healthStore = HKHealthStore()
    
    init(info: DayViewModel) {
        self.info = info
        requestAuthorization()
        fetchWorkouts()
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
    
    func fetchWorkouts() {
        let startOfDay = Calendar.current.startOfDay(for: info.date)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: info.date, options: .strictStartDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        
        let query = HKSampleQuery(sampleType: HKSampleType.workoutType(), predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { [weak self] (_, samples, error) in
            
            guard let workouts = samples as? [HKWorkout], error == nil else {
                print("workout fetch failed")
                return
            }
            
            self?.addWorkoutEntries(workouts: workouts)
        }
        
        healthStore.execute(query)
    }
    
    func addWorkoutEntries(workouts: [HKWorkout]) {
        for workout in workouts {
            let calories = workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0
            
            let workoutName = workoutTypetoName(workout.workoutActivityType)
                        
            DispatchQueue.main.async {
                
                let containsEntry = self.info.entryList.entries.contains {
                    $0.id == workout.uuid
                }
                
                if !containsEntry {
                    let workoutEntry = Entry(id: workout.uuid, name: workoutName, consume: false, kcalCount: Int(calories), apple: true)
                                        
                    self.info.addEntry(entry: workoutEntry)
                }
            }
        }
    }
    
    func fetchTotalActiveCalories(completion: @escaping (Int) -> Void) {
        let dayStart = Calendar.current.startOfDay(for: info.date)
        let dayEnd = Calendar.current.date(byAdding: .day, value: 1, to: dayStart)!
        
        let predicate = HKQuery.predicateForSamples(withStart: dayStart, end: dayEnd, options: .strictStartDate)
        let activeEnergyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        
        let query = HKStatisticsQuery(quantityType: activeEnergyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            guard error == nil, let sum = result?.sumQuantity() else {
                completion(0)
                return
            }
            
            let totalCalories = Int(sum.doubleValue(for: HKUnit.kilocalorie()))
            completion(totalCalories)
        }
        
        healthStore.execute(query)
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
        case .boxing: return "Boxing"
        case .climbing: return "Climbing"
        case .crossCountrySkiing: return "Cross Country Skiing"
        case .crossTraining: return "Cross Training"
        case .curling: return "Curling"
        case .dance: return "Dance"
        case .danceInspiredTraining: return "Dance Inspired Training"
        case .elliptical: return "Elliptical"
        case .equestrianSports: return "Equestrian Sports"
        case .fishing: return "Fishing"
        case .functionalStrengthTraining: return "Functional Strength Training"
        case .golf: return "Golf"
        case .handCycling: return "Hand Cycling"
        case .highIntensityIntervalTraining: return "High Intensity Interval Training"
        case .hiking: return "Hiking"
        case .hunting: return "Hunting"
        case .martialArts: return "Martial Arts"
        case .mindAndBody: return "Mind and Body"
        case .mixedCardio: return "Mixed Cardio"
        case .paddleSports: return "Paddle Sports"
        case .play: return "Play"
        case .racquetball: return "Racquetball"
        case .rowing: return "Rowing"
        case .sailing: return "Sailing"
        case .skatingSports: return "Skating Sports"
        case .snowSports: return "Snow Sports"
        case .squash: return "Squash"
        case .stairClimbing: return "Stair Climbing"
        case .surfingSports: return "Surfing Sports"
        case .swimming: return "Swimming"
        case .tableTennis: return "Table Tennis"
        case .tennis: return "Tennis"
        case .waterFitness: return "Water Fitness"
        case .waterPolo: return "Water Polo"
        case .waterSports: return "Water Sports"
        case .wrestling: return "Wrestling"
        case .yoga: return "Yoga"
        case .pilates: return "Pilates"
        default: return "Apple Workout"
        }
    }
}
