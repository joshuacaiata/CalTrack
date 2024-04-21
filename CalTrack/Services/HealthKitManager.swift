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
    
    // Request authorization to use user healt hdata
    func requestAuthorization() async -> Bool {
        await withCheckedContinuation { continuation in
            guard HKHealthStore.isHealthDataAvailable() else {
                // if health data not available then return false
                continuation.resume(returning: false)
                return
            }
            
            // set what we are looking for
            let types: Set = [
                HKQuantityType.workoutType(),
                HKQuantityType(.activeEnergyBurned)
            ]
            
            healthStore.requestAuthorization(toShare: nil, read: types) { success, _ in
                // if they reject then return false
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
                
                // return if we got everything we need
                continuation.resume(returning: allAuthorized)
            }
        }
    }

    // Get the total active calories
    func fetchTotalActiveCalories(for date: Date) async -> Int {
        await withCheckedContinuation { continuation in
            // Set the bounds for when we are searching
            let dayStart = Calendar.current.startOfDay(for: date)
            let dayEnd = Calendar.current.date(byAdding: .day, value: 1, to: dayStart)!
            
            // Get predictae and active energy types
            // Predicate is used to filter the objects returned from the HealthKit store
            let predicate = HKQuery.predicateForSamples(withStart: dayStart, end: dayEnd, options: .strictStartDate)
            let activeEnergyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
            
            // Construct the query
            let query = HKStatisticsQuery(quantityType: activeEnergyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
                guard error == nil, let sum = result?.sumQuantity() else {
                    // If it doesnt work return 0
                    continuation.resume(returning: 0)
                    return
                }
                
                // Otherwise return the total calories
                let totalCalories = Int(sum.doubleValue(for: HKUnit.kilocalorie()))
                continuation.resume(returning: totalCalories)
            }
            
            healthStore.execute(query)
        }
    }
}
