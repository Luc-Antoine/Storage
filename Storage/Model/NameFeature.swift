//
//  NameFeature.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 13/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation
import GRDB

struct NameFeature {
    let id: Int
    var name: String
    let categoryId: Int
    
    init(id: Int, name: String, categoryId: Int) {
        self.id = id
        self.name = name
        self.categoryId = categoryId
    }
}

extension NameFeature: Equatable {
    static func == (lhs: NameFeature, rhs: NameFeature) -> Bool {
        return lhs.id == rhs.id
    }
}

extension NameFeature: FetchableRecord, PersistableRecord {
    init(row: Row) {
        id = row["id"]
        name = row["name"]
        categoryId = row["category_id"]
    }
    
    func encode(to container: inout PersistenceContainer) {
        
    }
}
