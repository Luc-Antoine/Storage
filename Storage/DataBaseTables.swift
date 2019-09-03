//
//  DataBaseTables.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 06/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

extension DataBase {
    
    func createCategoryTable() {
        do {
            try dbQueue?.write({ db in
                try db.execute(sql: """
                    CREATE TABLE Category (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        name TEXT NOT NULL,
                        favorite BOOL
                    )
                """)
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func createItemTable() {
        do {
            try dbQueue?.write({ db in
                try db.execute(sql: """
                    CREATE TABLE Item (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        name TEXT NOT NULL,
                        category_id INTEGER,
                        favorite BOOL,
                        FOREIGN KEY (category_id)
                        REFERENCES Category(id)
                    )
                """)
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func createAnnotationTable() {
        do {
            try dbQueue?.write({ db in
                try db.execute(sql: """
                    CREATE TABLE Annotation (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        title TEXT NOT NULL,
                        subtitle TEXT,
                        comment TEXT,
                        lat DOUBLE,
                        lng DOUBLE,
                        favorite BOOL
                    )
                """)
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func createNameFeaturesTable() {
        do {
            try dbQueue?.write({ db in
                try db.execute(sql: """
                    CREATE TABLE Name_feature (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        name TEXT NOT NULL,
                        category_id INTEGER,
                        FOREIGN KEY (category_id)
                        REFERENCES Category(id)
                    )
                """)
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func createFeaturesTable() {
        do {
            try dbQueue?.write({ db in
                try db.execute(sql: """
                    CREATE TABLE Feature (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        name TEXT NOT NULL,
                        count INTEGER NOT NULL DEFAULT 1
                    )
                """)
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func createItemFeatureTable() {
        do {
            try dbQueue?.write({ db in
                try db.execute(sql: """
                    CREATE TABLE Item_feature (
                        item_id INTEGER,
                        name_features_id INTEGER,
                        features_id INTEGER,
                        FOREIGN KEY (item_id)
                        REFERENCES Item(id),
                        FOREIGN KEY (name_features_id)
                        REFERENCES Name_feature(id),
                        FOREIGN KEY (features_id)
                        REFERENCES Feature(id)
                    )
                """)
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
}
