//
//  ModelController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 22/03/2017.
//  Copyright © 2017 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class ModelController {
    
    var currentPosition: Position? { return location.currentLocation?.coordinate.position }
    
    private let location = Location()
    
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

extension Position: CustomStringConvertible {
    var description: String {
        return "(\(lat), \(lng))"
    }
}

extension UIColor {
    static var appColor: UIColor {
        return UIColor(red: 49/255, green: 140/255, blue: 231/255, alpha: 1)
    }
}
