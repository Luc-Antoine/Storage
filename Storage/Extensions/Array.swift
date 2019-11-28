//
//  Array.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 20/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
    
    func set(_ element: Element) -> [Element] {
        var array: [Element] = self
        let index = self.firstIndex(of: element)
        if index == nil {
            array.append(element)
        } else {
            array.remove(at: index!)
        }
        return array
    }
}

extension Array where Element == Int {
    func intArrayToString() -> String {
        var string: String = ""
        for int in self {
            string += String(int) + ","
        }
        return String(string.dropLast())
    }
}
