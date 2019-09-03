//
//  Feature.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 13/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation
import GRDB

struct Feature {
    let id: Int
    let name: String
    let count: Int
    let itemId: Int
    let nameFeatureId: Int
    let featureId: Int
    
    init(id: Int, name: String, count: Int, itemId: Int, nameFeatureId: Int, featureId: Int) {
        self.id = id
        self.name = name
        self.count = count
        self.itemId = itemId
        self.nameFeatureId = nameFeatureId
        self.featureId = featureId
    }
}

extension Feature: Equatable {
    static func == (lhs: Feature, rhs: Feature) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Feature: FetchableRecord, PersistableRecord {
    init(row: Row) {
        id = row["id"]
        name = row["name"]
        count = row["count"]
        itemId = row["item_id"]
        nameFeatureId = row["name_features_id"]
        featureId = row["features_id"]
    }
    
    func encode(to container: inout PersistenceContainer) {
        print(container)
    }
}
