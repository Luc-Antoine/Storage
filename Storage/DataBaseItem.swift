//
//  DataBaseItem.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 06/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

extension DataBase {
    
    func insert(_ item: Item) {
        do {
            try dbQueue!.write({ db in
                try db.execute(
                    sql: "INSERT INTO Item (name, category_id, favorite) VALUES (:name, :category_id, :favorite)",
                    arguments: ["name": item.name, "category_id": item.categoryId, "favorite": item.favorite])
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func select(_ categoryId: Int) -> [Item] {
        do {
            return try dbQueue!.read { db in
                try Item.fetchAll(db, sql: "SELECT * FROM Item WHERE category_id = \(categoryId)")
            }
        } catch {
            NSLog(error.localizedDescription)
        }
        return []
    }
    
    func update(_ item: Item) {
        do {
            try dbQueue!.write({ db in
                try db.execute(
                    sql: "UPDATE Item SET favorite = :favorite WHERE id = :id",
                    arguments: ["id":item.id, "favorite":!item.favorite])
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func updateName(_ item: Item) {
        do {
            try dbQueue!.write({ db in
                try db.execute(
                    sql: "UPDATE Item SET name = :name WHERE id = :id",
                    arguments: ["id":item.id, "name":item.name])
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func delete(_ items: [Item]) {
        do {
            try dbQueue!.write({ db in
                for item in items {
                    try db.execute(
                        sql: "DELETE FROM `Item` WHERE id = :id",
                        arguments: ["id":item.id]
                    )
                }
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func delete(_ categoryId: Int) {
        do {
            try dbQueue!.write({ db in
                try db.execute(
                    sql: "DELETE FROM `Item` WHERE category_id = :category_id",
                    arguments: ["category_id":categoryId]
                )
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
}
