//
//  DataBaseFeatures.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 13/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

extension DataBase {
    
    func insert(_ feature: Feature) {
        do {
            try dbQueue!.write({ db in
                try db.execute(
                    sql: "INSERT INTO Feature (name) VALUES (:name)",
                    arguments: ["name":feature.name]
                )
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func select(_ itemId: Int) -> [Feature] {
        do {
            return try dbQueue!.read { db in
                try Feature.fetchAll(db, sql: "SELECT * FROM Feature, Item_feature WHERE Feature.id = Item_feature.features_id AND Item_feature.item_id = \(itemId)")
            }
        } catch {
            NSLog(error.localizedDescription)
        }
        return []
    }
    
    func select(nameFeaturesId: Int) -> [Feature] {
        do {
            return try dbQueue!.read { db in
                try Feature.fetchAll(db, sql: "SELECT * FROM Feature, Item_feature WHERE Feature.id = Item_feature.features_id AND Item_feature.name_features_id = \(nameFeaturesId)")
            }
        } catch {
            NSLog(error.localizedDescription)
        }
        return []
    }
    
    func select(itemsId: String) -> [Feature] {
        do {
            return try dbQueue!.read { db in
                try Feature.fetchAll(db, sql: "SELECT * FROM Feature, Item_feature WHERE Feature.id = Item_feature.features_id AND Item_feature.item_id IN (\(itemsId))")
            }
        } catch {
            NSLog(error.localizedDescription)
        }
        return []
    }
    
    func lastFeature(_ itemsId: Int, _ nameFeaturesId: Int) -> Feature? {
        do {
            return try dbQueue!.read { db in
                return try Feature.fetchOne(db, sql: "SELECT * FROM Feature, Item_feature WHERE Feature.id = Item_feature.features_id AND Item_feature.item_id = (\(itemsId)) AND Item_feature.name_features_id = \(nameFeaturesId)")
            }
        } catch {
            NSLog(error.localizedDescription)
        }
        return nil
    }
    
    func lastFeatureId() -> Int {
        var lastId: Int?
        do {
            lastId = try dbQueue!.read { db in
                try Int.fetchOne(db, sql: "SELECT id FROM Feature ORDER BY id DESC LIMIT 1")
            }
        } catch {
            NSLog(error.localizedDescription)
        }
        return (lastId ?? 0) + 1
    }
    
    func check(_ feature: Feature) -> Feature? {
        do {
            return try dbQueue!.read { db in
                try Feature.fetchOne(db, sql: "SELECT * FROM Feature, Item_feature WHERE name = :name", arguments: ["name":feature.name])
            }
        } catch {
            NSLog(error.localizedDescription)
        }
        return nil
    }
    
    func update(_ feature: Feature) {
        do {
            try dbQueue!.write({ db in
                try db.execute(
                    sql: "UPDATE Feature SET name = :name WHERE id = :id",
                    arguments: ["id":feature.id, "name":feature.name]
                )
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func increase(_ feature: Feature) {
        do {
            try dbQueue!.write({ db in
                try db.execute(
                    sql: "UPDATE Feature SET count = :count WHERE id = :id",
                    arguments: ["id":feature.id, "count":feature.count + 1]
                )
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func decrease(_ feature: Feature) {
        do {
            try dbQueue!.write({ db in
                try db.execute(
                    sql: "UPDATE Feature SET count = :count WHERE id = :id",
                    arguments: ["id":feature.id, "count":feature.count - 1]
                )
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func delete(_ feature: Feature) {
        do {
            try dbQueue!.write({ db in
                try db.execute(
                    sql: "DELETE FROM `Feature` WHERE id = :id ; DELETE FROM `Item_feature` WHERE item_id = :item_id AND name_features_id = :name_features_id AND features_id = :features_id",
                    arguments: ["id":feature.id, "item_id":feature.itemId, "name_features_id":feature.nameFeatureId, "features_id":feature.featureId]
                )
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func delete(_ featuresId: [Int]) {
        do {
            try dbQueue!.write({ db in
                for id in featuresId {
                    try db.execute(
                        sql: "DELETE FROM `Feature` WHERE id = :id",
                        arguments: ["id":id]
                    )
                }
            })
        } catch {
            NSLog(error.localizedDescription)
        }
    }
}
