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
    
    private func openDatabase() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("CalTrack.sqlite")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return
        }
    }
    
    private func createTable() {
        let createTableStr = """
        CREATE TABLE IF NOT EXISTS Entries(
        Id TEXT PRIMARY KEY,
        FoodName TEXT,
        EntryDate TEXT,
        Consume BOOLEAN,
        KcalCount INTEGER);
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
    
    func insertEntry(entry: Entry) {
        //id: UUID, foodName: String, entryDate: Date, consume: Bool, kcalCount: Int
        let id = entry.id
        let name = entry.name
        let date = entry.date
        let consume = entry.consume
        let kcalCount = entry.kcalCount
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        let insertStatementString = "INSERT INTO Entries (Id, FoodName, EntryDate, Consume, KcalCount) VALUES (?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            let idString = id.uuidString // Convert UUID to String
            sqlite3_bind_text(insertStatement, 1, (idString as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (dateString as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 4, consume ? 1 : 0)
            sqlite3_bind_int(insertStatement, 5, Int32(kcalCount))

            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
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
            print("ID | FoodName | EntryDate | Consume | KcalCount")
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = String(cString: sqlite3_column_text(queryStatement, 0))
                let foodName = String(cString: sqlite3_column_text(queryStatement, 1))
                let entryDate = String(cString: sqlite3_column_text(queryStatement, 2))
                let consume = sqlite3_column_int(queryStatement, 3) != 0 ? "true" : "false"
                let kcalCount = sqlite3_column_int(queryStatement, 4)

                print("\(id) | \(foodName) | \(entryDate) | \(consume) | \(kcalCount)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
    }

    deinit {
        sqlite3_close(db)
    }
}
