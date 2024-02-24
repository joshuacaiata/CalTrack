//
//  UpdateTargetView.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/23/24.
//

import SwiftUI

struct UpdateTargetView: View {
    @Binding var target: Int
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Target calories", value: $target, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Done") {
                    isPresented = false
                }
                .padding()
            }
        }
        .navigationTitle("Update Target Calories")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Dismiss") {
                    isPresented = false
                }
            }
        }
    }
}

#Preview {
    UpdateTargetView(target: .constant(2250), isPresented: .constant(true))
}
