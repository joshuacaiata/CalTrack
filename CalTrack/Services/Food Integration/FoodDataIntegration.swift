//
//  FoodDataIntegration.swift
//  CalTrack
//
//  Created by Joshua Caiata on 4/12/24.
//

import Foundation

class FoodDataIntegration {
    let apiKey = ProcessInfo.processInfo.environment["FC_API_KEY"]

    func fetchFoods(query: String) async throws -> [FoodItem] {
        let urlString = "https://api.nal.usda.gov/fdc/v1/foods/search?query=\(query)&dataType=Foundation,SR%20Legacy&pageSize=20&pageNumber=0&sortBy=dataType.keyword&sortOrder=asc&api_key=\(String(describing: self.apiKey))"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let foodsResponse = try JSONDecoder().decode(FoodsResponse.self, from: data)
        let foodItems = foodsResponse.foods.map { FoodItem(name: $0.description) }
        print(foodItems)
        return foodItems
    }
}
