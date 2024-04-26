//
//  FoodView.swift
//  CalTrack
//
//  Created by Joshua Caiata on 4/11/24.
//

import SwiftUI

// View for each individual result from search
struct FoodView: View {
    var item: FoodItem
    
    init(item: FoodItem) {
        self.item = item
    }
    
    var body: some View {
        HStack {
            Text(self.item.name)
                .font(.title3)
            
            Spacer()
        }
        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    FoodView(item: FoodItem(name: "Apple", calories: 100))
}
