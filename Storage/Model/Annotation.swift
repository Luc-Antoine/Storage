//
//  Annotation.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 07/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation
import GRDB

struct Annotation {
    let id: Int
    var title: String
    var subtitle: String
    var comment: String
    let lat: Double
    let lng: Double
    var favorite: Bool
    var categories: [Int]
    var distance: Double
    
    init(id: Int, title: String, subtitle: String, comment: String, lat: Double, lng: Double, favorite: Bool, categories: [Int]) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.comment = comment
        self.lat = lat
        self.lng = lng
        self.favorite = favorite
        self.categories = categories
        self.distance = 0
    }
}

extension Annotation: Equatable {
    static func == (lhs: Annotation, rhs: Annotation) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Annotation: FetchableRecord, PersistableRecord {
    init(row: Row) {
        id = row["id"]
        title = row["title"]
        subtitle = row["subtitle"]
        comment = row["comment"]
        lat = row["lat"]
        lng = row["lng"]
        favorite = row["favorite"]
        categories = String(row["categories"]).stringToIntArray()
        distance = 0
    }
    
    func encode(to container: inout PersistenceContainer) {
        
    }
}

extension Annotation: Selectable {
    var name: String {
        return title
    }
}
