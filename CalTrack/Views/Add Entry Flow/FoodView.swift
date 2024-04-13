//
//  FoodView.swift
//  CalTrack
//
//  Created by Joshua Caiata on 4/11/24.
//

import SwiftUI

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
            
            Text("SELECT")
                .font(.footnote)
                .fontWeight(.bold)
        }
    }
    
    /*
     var body: some View {
         HStack{
             Text("\(entry.name)")
                 .font(.title3)
             Spacer()
             HStack {
                 Text(entry.consume ? "-\(entry.kcalCount)" : "+\(entry.kcalCount)")
                     .font(.title3)
                     .fontWeight(.bold)
                 Text("kcal")
                     .font(.body)
             }
             .foregroundColor(entry.calColor)
             .padding(.vertical, 20.0)
             .padding(.horizontal, 10)
         }
         .background(Color.white)
         .foregroundColor(.black)
     }
     */
}

#Preview {
    FoodView(item: FoodItem(name: "Apple", calories: 100))
}
