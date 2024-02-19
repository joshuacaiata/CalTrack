//
//  AddEntryView.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/18/24.
//

import SwiftUI

struct AddEntryView: View {
    enum Selection {
        case food, activity
    }
    
    @State private var selection: Selection = .food
    @State private var text: String = ""
    @State private var isEditing: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button("Food") {
                    selection = .food
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.black)
                .padding()
                .background(selection == .food ? AppColors.CalTrackLightBlue: Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(selection == .food ? AppColors.CalTrackLightBlue : AppColors.CalTrackStroke, lineWidth: 2))
                
                Button("Activity") {
                    selection = .activity
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.black)
                .padding()
                .background(selection == .activity ? AppColors.CalTrackLightBlue : Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(selection == .activity ? AppColors.CalTrackLightBlue : AppColors.CalTrackStroke, lineWidth: 2)
                )
            }
            .padding(.horizontal, 30)
            
            HStack{
                Spacer()
                
                if isEditing {
                    TextField("Entry name", text: $text, onCommit: {
                        isEditing = false
                    })
                    .font(.title3)
                    .padding()
                    .onTapGesture {
                        isEditing = true
                    }
                } else {
                    Text(text)
                        .font(.title3)
                        .padding()
                        .onTapGesture {
                            isEditing = true
                        }
                }
                Spacer()
            }
            .border(AppColors.CalTrackStroke)
            .padding(.horizontal, 30)
            .padding(.top, 20)
            .onTapGesture {
                isEditing = true
            }
        }
    }
}

#Preview {
    AddEntryView()
}
