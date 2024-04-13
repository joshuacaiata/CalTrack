//
//  FoodItem.swift
//  CalTrack
//
//  Created by Joshua Caiata on 4/11/24.
//

import Foundation

class FoodItem: Decodable {
    var name: String
    var calories: Int?
    
    init(name: String, calories: Int?) {
        self.name = name
        self.calories = calories
    }
}
