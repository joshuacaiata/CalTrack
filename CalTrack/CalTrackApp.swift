//
//  CalTrackApp.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/13/24.
//

import SwiftUI

@main
struct CalTrackApp: App {
    @Environment (\.scenePhase) var scenePhase
    
    init() {
        DatabaseManager.shared.openDatabase()
    }
    
    private func handleSceneChange() {
        switch scenePhase {
        case .background:
            DatabaseManager.shared.closeDatabase()
        case .active:
            DatabaseManager.shared.openDatabase()
        default:
            break
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .onChange(of: scenePhase) {
            handleSceneChange()
        }
    }
}
