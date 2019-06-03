//
//  Calculator.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 02/02/2017.
//  Copyright © 2017 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

struct Calculator {
    var numberLeft: Double = 0.0
    var numberRight: Double = 0.0
    var record: Bool = false
    var recordOperation: String = ""
    var recordNumber: String = ""
    
    func result(numberLeft: Double, numberRight: Double, operative: String) -> Double {
        switch operative {
        case "add":
            return numberLeft + numberRight
        case "subtract":
            return numberLeft - numberRight
        case "multiply":
            return numberLeft * numberRight
        case "divide":
            return numberLeft / numberRight
        default:
            return 0
        }
    }
}
