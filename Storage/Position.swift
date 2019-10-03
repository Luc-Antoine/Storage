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

extension Position {
    var currentPosition: Position? { return location.currentLocation?.coordinate.position }
    
    func calculateDistance(distance: Double) -> String {
        let numberFormatter = NumberFormatter()
        var unit: String = ""
        var number: NSNumber = 0
        numberFormatter.maximumFractionDigits = 0
        if distance >= 1000 {
            number = NSNumber(floatLiteral: distance / 1000)
            unit = " km"
        } else {
            number = NSNumber(floatLiteral: distance)
            unit = " m"
        }
        return numberFormatter.string(from: number)! + unit
    }
}
