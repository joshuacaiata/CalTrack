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
    }
    
    let foods: [Food]
}
