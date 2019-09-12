//
//  Category.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 07/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation
import GRDB

struct Category {
    let id: Int
    let name: String
    var favorite: Bool
    
    
    init(id: Int, name: String, favorite: Bool) {
        self.id = id
        self.name = name
        self.favorite = favorite
    }
}

extension Category: Equatable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Category: FetchableRecord, PersistableRecord {
    init(row: Row) {
        id = row["id"]
        name = row["name"]
        favorite = row["favorite"]
    }
    
    func encode(to container: inout PersistenceContainer) {
        print(container)
    }
}

extension Category: SortType {
    
}
