//
//  ItemFeature.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 17/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation
import GRDB

struct ItemFeature {
    let itemId: Int
    let nameFeatureId: Int
    let featureId: Int
    
    init(itemId: Int, nameFeatureId: Int, featureId: Int) {
        self.itemId = itemId
        self.nameFeatureId = nameFeatureId
        self.featureId = featureId
    }
}

extension ItemFeature: FetchableRecord, PersistableRecord {
    init(row: Row) {
        itemId = row["item_id"]
        nameFeatureId = row["name_features_id"]
        featureId = row["features_id"]
    }
    
    func encode(to container: inout PersistenceContainer) {
        
    }
}
