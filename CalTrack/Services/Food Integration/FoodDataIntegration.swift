//
//  FoodDataIntegration.swift
//  CalTrack
//
//  Created by Joshua Caiata on 4/12/24.
//

import Foundation

class FoodDataIntegration {
    let apiKey = ProcessInfo.processInfo.environment["API_KEY"]
    

    func fetchFoods(query: String) async throws -> [FoodItem] {
        let urlString = "https://api.nal.usda.gov/fdc/v1/foods/search?query=\(query)&dataType=Foundation,SR%20Legacy&pageSize=20&pageNumber=0&sortBy=dataType.keyword&sortOrder=asc&api_key=\(String(describing: self.apiKey))"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let foodsResponse = try JSONDecoder().decode(FoodsResponse.self, from: data)
        let foodItems = foodsResponse.foods.compactMap { food -> FoodItem? in
            guard let energyNutrient = food.foodNutrients.first(where: { $0.nutrientName.contains("Energy")}) else {
                return nil
            }
            let value = energyNutrient.unitName == "kJ" ? energyNutrient.value * 0.239 : energyNutrient.value
            return FoodItem(name: food.description, calories: Int(value))
        }
        
        return foodItems
    }
}
