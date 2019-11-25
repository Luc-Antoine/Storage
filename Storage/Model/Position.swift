//
//  Position.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 03/10/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

struct Position {
    let lat: Double
    let lng: Double
    
    private let location = Location()
    
    init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
}

extension Position: CustomStringConvertible {
    var description: String {
        return "(\(lat), \(lng))"
    }
}
