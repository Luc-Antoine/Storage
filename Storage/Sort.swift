//
//  Sort.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 10/09/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

protocol SortType {
    var name: String { get }
    var favorite: Bool { get }
}

enum Sort: Int {
    case increasing = 0
    case decreasing
    case favoritesFirst
    case favoritesLast
    
    func sort<T: SortType>(_ categories: [T]) -> [T] {
        switch self {
        case .increasing:
            return categories.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
        case .decreasing:
            return categories.sorted(by: { $0.name.lowercased() > $1.name.lowercased() })
        case .favoritesFirst:
            return categories.sorted(by: { $0.favorite && !$1.favorite })
        case .favoritesLast:
            return categories.sorted(by: { !$0.favorite && $1.favorite })
        }
    }
}
