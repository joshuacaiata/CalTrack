//
//  HealthKitManager.swift
//  CalTrack
//
//  Created by Joshua Caiata on 3/15/24.
//

import Foundation
import HealthKit
import SwiftUI

class HealthKitManager {    
    let healthStore = HKHealthStore()
    @Published var healthKitAuthorized: Bool = false
    
    init() {
        Task {
            self.healthKitAuthorized = await requestAuthorization()
        }
    }
    
    func requestAuthorization() async -> Bool {
        await withCheckedContinuation { continuation in
            guard HKHealthStore.isHealthDataAvailable() else {
                continuation.resume(returning: false)
                return
            }
            
            let types: Set = [
                HKQuantityType.workoutType(),
                HKQuantityType(.activeEnergyBurned)
            ]
            
            healthStore.requestAuthorization(toShare: nil, read: types) { success, _ in
                if !success {
                    continuation.resume(returning: false)
                    return
                }
                
                // Check specific authorization status for each type
                var allAuthorized = true
                for type in types {
                    let status = self.healthStore.authorizationStatus(for: type)
                    if status != .sharingAuthorized {
                        allAuthorized = false
                        break
                    }
                }
                continuation.resume(returning: allAuthorized)
            }
        }
    }

    
    func fetchTotalActiveCalories(for date: Date) async -> Int {
        await withCheckedContinuation { continuation in
            let dayStart = Calendar.current.startOfDay(for: date)
            let dayEnd = Calendar.current.date(byAdding: .day, value: 1, to: dayStart)!
            
            let predicate = HKQuery.predicateForSamples(withStart: dayStart, end: dayEnd, options: .strictStartDate)
            let activeEnergyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
            
            let query = HKStatisticsQuery(quantityType: activeEnergyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
                guard error == nil, let sum = result?.sumQuantity() else {
                    continuation.resume(returning: 0)
                    return
                }
                
                let totalCalories = Int(sum.doubleValue(for: HKUnit.kilocalorie()))
                continuation.resume(returning: totalCalories)
            }
            
            healthStore.execute(query)
        }
    }
}
