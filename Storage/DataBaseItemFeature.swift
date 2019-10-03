//
//  DataBaseItemFeature.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 17/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

extension DataBase {
    
    func selectCount(_ index: Int) -> Int {
        do {
            return try dbQueue!.read { db in
                try Int.fetchOne(db, sql: "SELECT COUNT(*) FROM Item_feature WHERE name_features_id = \(index)")!
            }
        } catch {
            NSLog(error.localizedDescription)
        }
        return 0
    }
    
    func insert(_ nameFeature: NameFeature, item: Item) {
        do {
            try dbQueue!.write({ db in
                try db.execute(
                    sql: """
                        INSERT INTO Item_feature (item_id, name_features_id, features_id) VALUES (:item_id, :name_features_id,
                            (SELECT id FROM Feature ORDER BY id DESC LIMIT 1)
                        );
                    """,
                    arguments: ["item_id":item.id, "name_features_id":nameFeature.id]
                )
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func insert(_ item: Item, nameFeature: NameFeature, feature: Feature) {
        do {
            try dbQueue!.write({ db in
                try db.execute(
                    sql: "INSERT INTO Item_feature (item_id, name_features_id, features_id) VALUES (:item_id, :name_features_id,:features_id)",
                    arguments: ["item_id":item.id, "name_features_id":nameFeature.id, "features_id":feature.id]
                )
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func update(_ itemId: Int, _ nameFeatureId: Int, _ featureId: Int) {
        do {
            try dbQueue!.write({ db in
                try db.execute(
                    sql: "UPDATE Item_feature SET features_id = :features_id WHERE item_id = :item_id AND name_features_id = :name_features_id",
                    arguments: ["item_id":itemId, "name_features_id":nameFeatureId, "features_id":featureId]
                )
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func delete(_ item: Item, nameFeature: NameFeature, feature: Feature) {
        do {
            try dbQueue!.write({ db in
                try db.execute(
                    sql: "DELETE FROM `Item_feature` WHERE item_id = :item_id AND name_features_id = :name_features_id AND features_id = :features_id",
                    arguments: ["item_id":item.id,"name_features_id":nameFeature.id,"features_id":feature.id]
                )
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func delete(_ item: Item) {
        do {
            try dbQueue!.write({ db in
                try db.execute(
                    sql: "DELETE FROM `Item_feature` WHERE item_id = :item_id",
                    arguments: ["item_id":item.id]
                )
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
}
