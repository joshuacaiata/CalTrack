//
//  SearchView.swift
//  CalTrack
//
//  Created by Joshua Caiata on 4/11/24.
//

import SwiftUI

struct SearchView: View {
    // Observe the entrylist view model to add entries
    @ObservedObject var dateManagerViewModel: DateManagerViewModel
    
    @State private var foodText: String = ""
    @State private var foodItems: [FoodItem] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var showingAddFoodView = false
    @State private var selectedFoodItem: FoodItem = FoodItem(name: "Apple", calories: 0)
    
    private var foodDataIntegration = FoodDataIntegration()
    
    init(dateManagerViewModel: DateManagerViewModel) {
        self.dateManagerViewModel = dateManagerViewModel
    }
    
    private func showFoodView(foodItem: FoodItem) {
        self.selectedFoodItem = foodItem
        self.showingAddFoodView = true
    }
    
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
        .sheet(isPresented: $showingAddFoodView) {
            AddFoodView(foodItem: $selectedFoodItem, dateManagerViewModel: dateManagerViewModel)
        }
        
        if let errorMessage = errorMessage {
            Text(errorMessage)
                .foregroundColor(.red)
        }
        
        if isLoading {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            Spacer()
        } else {
            List(foodItems, id: \.name) { item in
                FoodView(item: item)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showFoodView(foodItem: item)
                    }
            }
            .listStyle(PlainListStyle())
            .padding(.top, 30)
            .padding(.horizontal)
        }
    }
}

#Preview {
    SearchView(dateManagerViewModel: DateManagerViewModel(dateManager: DateManager(startingDate: Date())))
}
