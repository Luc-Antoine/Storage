//
//  Entities.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 07/02/2017.
//  Copyright © 2017 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

enum Sort: Int {
    case increasing = 0, decreasing, favoritesFirst, favoritesLast
}

//struct ArrayDisplay {
//    enum Sort: Int {
//        case increasing = 0, decreasing, favoritesFirst, favoritesLast
//    }
//}

enum NavBarItem {
    case add, delete
}

enum NavBarItemFilter {
    case add, delete, filter
}

struct Symbol {
    enum Light: String {
        case SUM = "SUM"
        case add = "add"
        case subtract = "subtract"
        case multiply = "multiply"
        case divide = "divide"
        case null = ""
        
        var light: String {
            switch self {
                case .SUM: return "SUM"
                case .add: return "add"
                case .subtract: return "subtract"
                case .multiply: return "multiply"
                case .divide: return "divide"
                case .null: return ""
            }
        }
    }
    
    enum Shadow: String {
        case empty = "empty"
        case used = "used"
        case selected = "selected"
        
        var shadow: String {
            switch self {
            case .empty: return "empty"
            case .used: return "used"
            case .selected: return "selected"
            }
        }
        
        var val: CGFloat {
            switch self {
                case .empty: return 0.9
                case .used: return 0.5
                case .selected: return 0
            }
        }
    }
}

extension Symbol {
    func getLight(light: String) -> Symbol.Light {
        switch light {
            case "SUM": return .SUM
            case "add": return .add
            case "subtract": return .subtract
            case "multiply": return .multiply
            case "divide": return .divide
            default:
                return .null
        }
    }
    
    func getShadow(shadow: String) -> Symbol.Shadow {
        switch shadow {
            case "empty": return .empty
            case "used": return .used
            case "selected": return .selected
            default:
                return .empty
        }
    }
    
    func getOperator(light: Symbol.Light) -> String {
        switch light {
            case .SUM: return ""
            case .add: return "+"
            case .subtract: return "-"
            case .multiply: return "*"
            case .divide: return "/"
            case .null: return ""
        }
    }
}

extension Notification.Name {
    static let reload = Notification.Name("reload")
}
