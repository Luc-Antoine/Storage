//
//  DataBaseNameFeatures.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 13/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

extension DataBase {
    
    func insert(_ nameFeature: NameFeature) {
        do {
            try dbQueue!.write({ db in
                try db.execute(
                    sql: "INSERT INTO Name_feature (name, category_id) VALUES (:name, :category_id)",
                    arguments: ["name":nameFeature.name, "category_id":nameFeature.categoryId])
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func select(_ categoryId: Int) -> [NameFeature] {
        do {
            return try dbQueue!.read { db in
                try NameFeature.fetchAll(db, sql: "SELECT * FROM Name_feature WHERE category_id = \(categoryId)")
            }
        } catch {
            NSLog(error.localizedDescription)
        }
        return []
    }
    
    func update(_ nameFeature: NameFeature) {
        do {
            try dbQueue!.write({ db in
                try db.execute(
                    sql: "UPDATE Name_feature SET name = :name WHERE id = :id",
                    arguments: ["id":nameFeature.id, "name":nameFeature.name])
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func delete(_ nameFeature: NameFeature) {
        do {
            try dbQueue!.write({ db in
                try db.execute(
                    sql: "DELETE FROM `Name_feature` WHERE id = :id",
                    arguments: ["id":nameFeature.id]
                )
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func delete(_ nameFeatures: [NameFeature]) {
        do {
            try dbQueue!.write({ db in
                for nameFeature in nameFeatures {
                    try db.execute(
                        sql: "DELETE FROM `Name_feature` WHERE id = :id",
                        arguments: ["id":nameFeature.id]
                    )
                }
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
}
