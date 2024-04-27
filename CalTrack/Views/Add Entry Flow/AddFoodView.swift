//
//  AddFoodView.swift
//  CalTrack
//
//  Created by Joshua Caiata on 4/14/24.
//

import SwiftUI

// View for adding the food, contains the dateManagerViewModel to add the entry and a FoodItem
// To calculate the calories needed
struct AddFoodView: View {
    @Binding var foodItem: FoodItem
    @State private var cals: Int
    @State private var amount: String = "100"
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var dateManagerViewModel: DateManagerViewModel
    
    var darkColor: Color {
        colorScheme == .dark ? AppColours.CalTrackNegativeDark : AppColours.CalTrackNegative
    }
    
    // Modify the constructor to accept a Binding<FoodItem>
    init(foodItem: Binding<FoodItem>, dateManagerViewModel: DateManagerViewModel) {
        self._foodItem = foodItem
        self._cals = State(initialValue: foodItem.wrappedValue.calories ?? 0)
        self.dateManagerViewModel = dateManagerViewModel
    }
    
    // Function for updating the calories based on entered weight
    private func updateCalories(_ newAmountString: String) {
        if let newAmount = Int(newAmountString) {
            self.cals = (self.foodItem.calories ?? 0) * newAmount / 100
        } else {
            self.cals = 0
        }
    }
    
    func getCurrentTime() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: Date())
        return components.hour! * 100 + components.minute!
    }

    
    // Adds entry when confirm is clicked
    func addEntry() {
        let newEntry = Entry(id: UUID(), name: foodItem.name, 
                             date: dateManagerViewModel.currentDate, consume: true,
                             kcalCount: cals, apple: false)
        dateManagerViewModel.selectedDayViewModel.addEntry(entry: newEntry)
        dateManagerViewModel.saveDate()
        
        if newEntry.consume {
            dateManagerViewModel.database.insertEntry(entry: newEntry, timeOfDay: getCurrentTime(), caloriesPer100g: foodItem.calories ?? 0)
        }
    }

    var body: some View {
        VStack{
            Text(self.foodItem.name.uppercased())
                .fontWeight(.bold)
                .padding(.top, 125)
                .padding(.bottom, 50)
                .padding(.horizontal, 30)
            
            
            HStack(alignment:.bottom) {
                Text("\(self.cals)")
                    .font(.system(size: 96))
                    .bold()
                
                
                Text("kcal")
                    .baselineOffset(18)
            }
            .foregroundStyle(darkColor)
            .onAppear {
                cals = foodItem.calories ?? 0
                updateCalories(amount)
            }
            
            Spacer()
                        
            HStack {
                Text("Amount in grams:")
                    .padding(.leading, 30)
                Spacer()
                TextField("100", text: $amount)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .frame(width: 100)
                    .border(AppColours.CalTrackStroke)
                    .keyboardType(.numberPad)
                    .onChange(of: amount) {oldValue, newValue in
                        updateCalories(newValue)
                    }
                Text("g")
                    .padding(.trailing, 30)
            }
            .padding(.top, 75)
            .padding(.bottom, 50)
        
            HStack {
                // This calls the add entry and closes the sheet
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(AppColours.CalTrackStroke, lineWidth: 2)
                )
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.leading, 30)
                
                // This calls the add entry and closes the sheet
                Button(action: {
                    addEntry()
                    dismiss()
                }) {
                    Text("Confirm")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .foregroundColor(.black)
                .background(AppColours.CalTrackLightBlue)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.trailing, 30)
                
            }
        }
    }
}

#Preview {
    AddFoodView(foodItem: .constant(FoodItem(name: "Granny Smith Apple", calories: 120)), dateManagerViewModel: DateManagerViewModel(dateManager: DateManager(startingDate: Date()), database: DatabaseManager()))
}
