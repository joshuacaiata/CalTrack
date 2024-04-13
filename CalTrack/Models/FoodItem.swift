//
//  FoodItem.swift
//  CalTrack
//
//  Created by Joshua Caiata on 4/11/24.
//

import Foundation

class FoodItem: Decodable {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
