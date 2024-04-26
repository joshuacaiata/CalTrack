//
//  AppColours.swift
//  CalTrack-Refactored
//
//  Created by Joshua Caiata on 3/13/24.
//

import Foundation
import SwiftUI

// This structure deals with colour management in the app
// Parent: N/A
// Children: N/A
struct AppColours {
    @Environment(\.colorScheme) static var colorScheme
    
    static let CalTrackLightBlue = Color(red: 0.7843137254901961, green: 0.9607843137254902, blue: 1.0)
    
    static let CalTrackYellow = Color(red: 0.9607843137254902, green: 1.0, blue: 0.7843137254901961)
    static let CalTrackPink = Color(red: 1.0, green: 0.7843137254901961, blue: 0.9607843137254902)
    static let CalTrackStroke = Color(red: 0.838, green: 0.838, blue: 0.838)
    static let CalTrackNegative = Color(red: 0.0, green: 0.2549019607843137, blue: 0.3137254901960784)
    static let CalTrackNegativeDark = Color(red: 0.0, green: 0.631372549, blue: 0.7764705882)

    //Color(red: 0.0, green: 0.631372549, blue: 0.7764705882)
    //static let CalTrackNegative = Color(red: 0.0, green: 0.2549019607843137, blue: 0.3137254901960784)
    static let CalTrackPositive = Color(red: 0.0, green: 0.8156862745098039, blue: 0.12941176470588237)
}
