//
//  SQLite.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 24/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import SQLite3
import Foundation

import GRDB

enum SQLiteError: LocalizedError {
    case OpenDatabase
    case Prepare
    case Step
    case Bind
    
    public var errorDescription: String {
        switch self {
        case .OpenDatabase:
            return "Unable to open database."
        case .Prepare:
            return "Unable to open database."
        case .Step:
            return "Unable to open database."
        case .Bind:
            return "Unable to open database."
        }
    }
}

enum ServerRequestError: LocalizedError {
    case badRequest
    case serverError(code: Int)
    case noData
    case malformedJSON
    
    public var errorDescription: String? {
        switch self {
        case .badRequest: return "Bad Request"
        case .serverError(let code): return "Server error \(code)"
        case .noData: return "No Data"
        case .malformedJSON: return "Malformed JSON"
        }
    }
}

class SQL {
    fileprivate let dbPointer: OpaquePointer?
    
    fileprivate init(dbPointer: OpaquePointer?) {
        self.dbPointer = dbPointer
    }
    
    fileprivate var errorMessage: String {
        if let errorPointer = sqlite3_errmsg(dbPointer) {
            let errorMessage = String(cString: errorPointer)
            return errorMessage
        } else {
            return "No error message provided from sqlite."
        }
    }
    
    deinit {
        sqlite3_close(dbPointer)
    }
    
    static func open(path: String) throws -> SQL? {
        var db: OpaquePointer? = nil
        // 1
        if sqlite3_open(path, &db) == SQLITE_OK {
            // 2
            return SQL(dbPointer: db)
        } else {
            // 3
            defer {
                if db != nil {
                    sqlite3_close(db)
                }
            }
            
            if let errorPointer = sqlite3_errmsg(db) {
                let errorMessage = String.init(cString: errorPointer)
                NSLog(errorMessage)
                throw SQLiteError.OpenDatabase
            } else {
                NSLog("No error message provided from sqlite.")
                //throw SQLiteError.OpenDatabase(message: "No error message provided from sqlite.")
            }
        }
        return nil
    }
}



extension SQL {
    
    func connection(path: String) {
        do {
            let _ = try SQL.open(path: path)
            print("Successfully opened connection to database.")
        } catch { //  SQLiteError.OpenDatabase
            NSLog("Unable to open database. Verify that you created the directory described in the Getting Started section.")
        }
    }
    
    func prepareStatement(sql: String) throws -> OpaquePointer? {
        var statement: OpaquePointer? = nil
        guard sqlite3_prepare_v2(dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.Prepare
        }
        
        return statement
    }
}


