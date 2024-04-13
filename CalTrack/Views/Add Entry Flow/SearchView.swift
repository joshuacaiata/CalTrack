//
//  SearchView.swift
//  CalTrack
//
//  Created by Joshua Caiata on 4/11/24.
//

import SwiftUI

struct SearchView: View {
    @State private var foodText: String = ""
    @State private var foodItems: [FoodItem] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    private var foodDataIntegration = FoodDataIntegration()
    
    var body: some View {
        HStack{
            Spacer()
            
            // Where you enter the entry name
            TextField("Search for foods", text: $foodText)
                .font(.title3)
                .padding()
                .onChange(of: foodText) { oldValue, newValue in
                    Task {
                        isLoading = true
                        do {
                            let results = try await foodDataIntegration.fetchFoods(query: newValue)
                            foodItems = results
                        } catch {
                            print("Error fetching foods: \(error)")
                            foodItems = []
                        }
                        isLoading = false
                    }
                }
                
           
            Spacer()
        }
        .border(AppColours.CalTrackStroke)
        .padding(.horizontal, 30)
        .padding(.top, 20)
        
        if let errorMessage = errorMessage {
            Text(errorMessage)
                .foregroundColor(.red)
        }
        
        if isLoading {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        } else {
            List(foodItems, id: \.name) { item in
                FoodView(item: item)
            }
            .listStyle(PlainListStyle())
            .padding(.top, 30)
            .padding(.horizontal)
        }
    }
}

#Preview {
    SearchView()
}
