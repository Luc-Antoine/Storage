//
//  Item.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 07/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation
import GRDB

struct Item {
    let id: Int
    let name: String
    let categoryId: Int
    var favorite: Bool
    
    init(id: Int, name: String, categoryId: Int, favorite: Bool) {
        self.id = id
        self.name = name
        self.categoryId = categoryId
        self.favorite = favorite
    }
}

extension Item: Equatable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Item: FetchableRecord, PersistableRecord {
    init(row: Row) {
        id = row["id"]
        name = row["name"]
        categoryId = row["category_id"]
        favorite = row["favorite"]
    }
    
    func encode(to container: inout PersistenceContainer) {
        print(container)
    }
}

extension Item: SortType {
    
}

//extension Item {
//    
//    enum ItemsSort: Int {
//        case increasing = 0
//        case decreasing
//        case favoritesFirst
//        case favoritesLast
//        
//        func sort(_ items: [Item]) -> [Item] {
//            switch self {
//            case .increasing:
//                return items.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
//            case .decreasing:
//                return items.sorted(by: { $0.name.lowercased() > $1.name.lowercased() })
//            case .favoritesFirst:
//                return items.sorted(by: { $0.favorite && !$1.favorite })
//            case .favoritesLast:
//                return items.sorted(by: { !$0.favorite && $1.favorite })
//            }
//        }
//    }
//}
