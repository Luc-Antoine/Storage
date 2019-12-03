//
//  DataBaseAnnotation.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 15/03/2017.
//  Copyright © 2017 Luc-Antoine Dupont. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

extension DataBase {
    
    func insert(_ annotation: Annotation) {
        do {
            try dbQueue!.write({ db in
                try db.execute(
                    sql: "INSERT INTO Annotation (title, subtitle, comment, lat, lng, categories) VALUES (:title, :subtitle, :comment, :lat, :lng, :categories)",
                    arguments: ["title":annotation.title, "subtitle":annotation.subtitle, "comment":annotation.comment, "lat":annotation.lat, "lng":annotation.lng, "categories":annotation.categories.intArrayToString()])
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func select() -> [Annotation] {
        do {
            return try dbQueue!.read { db in
                try Annotation.fetchAll(db, sql: "SELECT * FROM Annotation")
            }
        } catch {
            NSLog(error.localizedDescription)
        }
        return []
    }
    
    func update(_ annotation: Annotation) {
        do {
            try dbQueue!.write({ db in
                try db.execute(
                    sql: "UPDATE Annotation SET title = :title, subtitle = :subtitle, comment = :comment, categories = :categories WHERE id = :id",
                    arguments: ["id":annotation.id, "title":annotation.title, "subtitle":annotation.subtitle, "comment":annotation.comment, "categories":annotation.categories.intArrayToString()])
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func delete(_ annotations: [Annotation]) {
        do {
            try dbQueue!.write({ db in
                for annotation in annotations {
                    try db.execute(
                        sql: "DELETE FROM `Annotation` WHERE id = :id",
                        arguments: ["id":annotation.id]
                    )
                }
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
}
