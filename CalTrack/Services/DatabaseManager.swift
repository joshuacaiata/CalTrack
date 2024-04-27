//
//  DatabaseManager.swift
//  CalTrack
//
//  Created by Joshua Caiata on 4/25/24.
//

import Foundation
import SQLite3

class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: OpaquePointer?
    
    init() {
        openDatabase()
        createTable()
    }
    
    func openDatabase() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("CalTrack.sqlite")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return
        }
    }
    
    func closeDatabase() {
        if db != nil {
            sqlite3_close(db)
        }
    }
    
    private func createTable() {
        let createTableStr = """
        CREATE TABLE IF NOT EXISTS Entries(
        Id TEXT PRIMARY KEY,
        FoodName TEXT,
        EntryDate TEXT,
        TimeOfDay INTEGER,
        Consume BOOLEAN,
        KcalCount INTEGER,
        CaloriesPer100g INTEGER);
        """
        
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, createTableStr, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Entries table created.")
            } else {
                print("Entries table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insertEntry(entry: Entry, timeOfDay: Int, caloriesPer100g: Int) {
        // Prepare the SQL statement
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: entry.date)
        
        let insertStatementString = "INSERT INTO Entries (Id, FoodName, EntryDate, TimeOfDay, Consume, KcalCount, CaloriesPer100g) VALUES (?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer?
        
        // Prepare the statement
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            let idString = entry.id.uuidString // Convert UUID to String
            sqlite3_bind_text(insertStatement, 1, (idString as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (entry.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (dateString as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 4, Int32(timeOfDay)) // Correct binding for an integer
            sqlite3_bind_int(insertStatement, 5, entry.consume ? 1 : 0)
            sqlite3_bind_int(insertStatement, 6, Int32(entry.kcalCount))
            sqlite3_bind_int(insertStatement, 7, Int32(caloriesPer100g))

            // Execute the statement
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row. Error: \(String(cString: sqlite3_errmsg(db)))")
            }
        } else {
            print("INSERT statement could not be prepared. Error: \(String(cString: sqlite3_errmsg(db)))")
        }
        sqlite3_finalize(insertStatement)
    }

    
    func deleteEntry(withId id: UUID) {
        let deleteStatementString = "DELETE FROM Entries WHERE Id = ?;"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            let idString = id.uuidString // Ensure this matches the format stored in the database
            sqlite3_bind_text(deleteStatement, 1, (idString as NSString).utf8String, -1, nil)

            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row. Error: \(String(cString: sqlite3_errmsg(db)))")
            }
        } else {
            print("DELETE statement could not be prepared. Error: \(String(cString: sqlite3_errmsg(db)))")
        }
        sqlite3_finalize(deleteStatement)
    }

    
    func fetchEntries() -> [Entry] {
        let queryStatementString = "SELECT * FROM Entries;"
        var queryStatement: OpaquePointer?
        var entries = [Entry]()

        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                guard let queryResultCol0 = sqlite3_column_text(queryStatement, 0) else {
                    print("Query result is nil for UUID.")
                    continue
                }
                let idString = String(cString: queryResultCol0)
                let id = UUID(uuidString: idString) // Convert String back to UUID
                guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
                    print("Query result is nil for FoodName.")
                    continue
                }
                let foodName = String(cString: queryResultCol1)
                let dateString = String(cString: sqlite3_column_text(queryStatement, 2))
                let consume = sqlite3_column_int(queryStatement, 3) != 0
                let kcalCount = Int(sqlite3_column_int(queryStatement, 4))

                // Convert date string back to Date object
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let entryDate = dateFormatter.date(from: dateString)!

                entries.append(Entry(id: id!, name: foodName, date: entryDate, consume: consume, kcalCount: kcalCount, apple: false))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return entries
    }
    
    func printDatabase() {
        let queryStatementString = "SELECT * FROM Entries;"
        var queryStatement: OpaquePointer?

        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            print("Query Result:")
            print("ID | FoodName | EntryDate | TimeOfDay | Consume | KcalCount | CaloriesPer100g")

            while sqlite3_step(queryStatement) == SQLITE_ROW {
                guard let id = sqlite3_column_text(queryStatement, 0),
                      let foodName = sqlite3_column_text(queryStatement, 1),
                      let entryDate = sqlite3_column_text(queryStatement, 2),
                      let timeOfDay = sqlite3_column_text(queryStatement, 3) else {
                    print("Error in fetching data")
                    continue
                }

                let consume = sqlite3_column_int(queryStatement, 4) != 0 ? "true" : "false"
                let kcalCount = sqlite3_column_int(queryStatement, 5)
                let caloriesPer100g = sqlite3_column_int(queryStatement, 6)

                print("\(String(cString: id)) | \(String(cString: foodName)) | \(String(cString: entryDate)) | \(String(cString: timeOfDay)) | \(consume) | \(kcalCount) | \(caloriesPer100g)")
            }
        } else {
            print("SELECT statement could not be prepared. Error: \(String(cString: sqlite3_errmsg(db)))")
        }
        sqlite3_finalize(queryStatement)
    }
    
    func fetchRecommendedFoods() -> [FoodItem] {
        let queryStatementString = """
        SELECT FoodName, CaloriesPer100g
        FROM Entries
        WHERE Consume = 1
        GROUP BY FoodName
        ORDER BY COUNT(*) DESC
        LIMIT 10;
        """
        var queryStatement: OpaquePointer?
        var recommendedFoods = [FoodItem]()

        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                if let foodName = sqlite3_column_text(queryStatement, 0),
                   let avgCalories = sqlite3_column_text(queryStatement, 1) {
                    let name = String(cString: foodName)
                    let calories = Int(String(cString: avgCalories))
                    let foodItem = FoodItem(name: name, calories: calories)
                    recommendedFoods.append(foodItem)
                }
            }
        } else {
            print("SELECT statement for recommended foods could not be prepared.")
        }
        sqlite3_finalize(queryStatement)
        return recommendedFoods
    }


    deinit {
        sqlite3_close(db)
    }
}
