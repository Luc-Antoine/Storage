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
    
    init(id: Int, title: String, subtitle: String, comment: String, lat: Double, lng: Double, favorite: Bool) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.comment = comment
        self.lat = lat
        self.lng = lng
        self.favorite = favorite
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
    }
    
    func encode(to container: inout PersistenceContainer) {
        print(container)
    }
}

extension Annotation: Selectable {
    var name: String {
        return title
    }
}
