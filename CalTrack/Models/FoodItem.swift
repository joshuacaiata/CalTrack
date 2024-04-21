//
//  FoodItem.swift
//  CalTrack
//
//  Created by Joshua Caiata on 4/11/24.
//

import Foundation

/*
To store information of a food item that will appear as a result of a search
The Food Data API will call will convert FoodsResponse into this class, FoodItem
*/
class FoodItem: Decodable, Equatable {
    var name: String
    var calories: Int?
    
    init(name: String, calories: Int?) {
        self.name = name
        self.calories = calories
    }
    
    static func == (lhs: FoodItem, rhs: FoodItem) -> Bool {
        return (lhs.name == rhs.name) && (rhs.calories == lhs.calories)
    }
}
