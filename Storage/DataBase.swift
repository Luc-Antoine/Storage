//
//  DataBase.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 02/02/2017.
//  Copyright © 2017 Luc-Antoine Dupont. All rights reserved.
//

import UIKit
import GRDB
import CoreData

class DataBase {
    var dbQueue: DatabaseQueue?
    let inMemoryDBQueue = DatabaseQueue()
    
    init() {
        do {
            let fileManager = FileManager.default
            let dbPath = try fileManager
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("dataBasePrivate.sqlite")
                .path
            dbQueue = try DatabaseQueue(path: dbPath)
        } catch {
            NSLog(error.localizedDescription)
        }
    }
}
