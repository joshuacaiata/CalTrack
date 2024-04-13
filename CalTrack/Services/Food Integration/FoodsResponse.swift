//
//  FoodsResponse.swift
//  CalTrack
//
//  Created by Joshua Caiata on 4/13/24.
//

import Foundation

struct FoodsResponse: Decodable {
    struct Food: Decodable {
        let description: String
        let foodNutrients: [FoodNutrient]
        
        struct FoodNutrient: Decodable {
            let nutrientId: Int
            let nutrientName: String
            let unitName: String
            let value: Double
        }
    }
    
    let foods: [Food]
}
