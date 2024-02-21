//
//  DataManager.swift
//  CalTrack
//
//  Created by Joshua Caiata on 2/21/24.
//

import Foundation

// Responsible for storing app's data
// Only one instance of this class will exist during runtime
class DataManager {
    
    // Shared instance of DataManager to be used in the app
    static let shared = DataManager()
    
    // Private initizalizer
    private init () {}
    
    // Saves the entrylist to the device's storage
    // Takes the entry list and a closure that gets called after the save operation
    // The closure returns a bool to express success or failure
    func saveEntryList(entryList: EntryList, completion: @escaping (Bool) -> Void) {
        // Try serializing into JSON data
        do {
            // Define filepath
            // use the getDocumentsDirectory() to find appropriate directory in the device
            let filePath = getDocumentsDirectory().appendingPathComponent("entryList.json")
            
            // Try encoding the entryList into JSON
            let data = try JSONEncoder().encode(entryList)
            
            // Write JSON data to file system at filepath we calculated
            // Set options to ensure atomic writing (all or nothing) and file protection
            try data.write(to: filePath, options: [.atomic, .completeFileProtection])
            
            completion(true)
        } catch {
            // If an error occurs, print an error
            print("Error saving entry list: \(error)")
            
            // Call the completion handler with false
            completion(false)
        }
    }
    
    // This function loads the entry list from the device's storage
    // Returns an optional entrylist object, returns nil if it fails
    func loadEntryList() -> EntryList? {
        do {
            // Define the filepath where the data is stored
            let filePath = getDocumentsDirectory().appendingPathComponent("entryList.json")
            
            // Try loading the JSON data from filesystem
            let data = try Data(contentsOf: filePath)
            
            // Try to decode the JSON data into an EntryList object
            let entryList = try JSONDecoder().decode(EntryList.self, from: data)
            
            // If decoding was successful return the entrylist
            return entryList
        } catch {
            // Catch the error, print, and return nil
            print("Error loading entry list: \(error)")
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
         
            .first! gets the first URL object from the returned array
         
         We are doing this safely with error handling in case the document directory cant be located
        */
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Could not find documents directory")
        }
        
        return url
    }
}
