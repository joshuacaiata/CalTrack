//
//  PersistenceManager.swift
//  CalTrack-Refactored
//
//  Created by Joshua Caiata on 3/14/24.
//

import Foundation

class PersistenceManager {
    static let shared = PersistenceManager()
    
    func saveDateManager(dateManager: DateManager) {
        do {
            let filePath = getDocumentsDirectory().appendingPathComponent("dateManager.json")
            
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            
            let data = try encoder.encode(dateManager)
            
            try data.write(to: filePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Error saving date manager: \(error)")
        }
    }
    
    func loadDateManager() -> DateManager? {
        do {
            let filePath = getDocumentsDirectory().appendingPathComponent("dateManager.json")
            
            let data = try Data(contentsOf: filePath)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let dateManager = try decoder.decode(DateManager.self, from: data)
            
            return dateManager
            
        } catch {
            print("Error loading date manager: \(error)")
            return nil
        }
    }
    
    // Get the URL of the documents directory on the device
    private func getDocumentsDirectory() -> URL {
        /*
        Fetch the first URL for the documents directory in the user domain
         
            .default returns the shared instance for most file operations
         
            urls(for: in:) generates array or URLs for a specified directory in a specified domain
                for: specifies the directory type, .documentDirectory wants the path to the user's documents directory
                in: specifies the domain of the search, .userDomainMask indicates we are looking for directories available to the user
         
            .first gets the first URL object from the returned array
         
         We are doing this safely with error handling in case the document directory cant be located
        */
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Could not find documents directory")
        }
        
        return url
    }
}
