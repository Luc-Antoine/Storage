//
//  DataBaseCategory.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 06/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

extension DataBase {
    
    func insert(_ category: Category) {
        do {
            try dbQueue!.write({ db in
                try db.execute(
                    sql: "INSERT INTO Category (name, favorite) VALUES (:name, :favorite)",
                    arguments: ["name":category.name, "favorite":category.favorite])
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func select() -> [Category] {
        do {
            return try dbQueue!.read { db in
                try Category.fetchAll(db, sql: "SELECT * FROM Category")
            }
        } catch {
            NSLog(error.localizedDescription)
        }
        return []
    }
    
    func update(_ category: Category) {
        do {
            try dbQueue!.write({ db in
                try db.execute(
                    sql: "UPDATE Category SET favorite = :favorite WHERE id = :id",
                    arguments: ["id":category.id, "favorite":!category.favorite])
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func delete(_ categories: [Category]) {
        do {
            try dbQueue!.write({ db in
                for category in categories {
                    try db.execute(
                        sql: "DELETE FROM `Category` WHERE id = :id",
                        arguments: ["id":category.id]
                    )
                }
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
}
