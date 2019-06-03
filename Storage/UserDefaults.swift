//
//  UserDefault.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 08/02/2017.
//  Copyright © 2017 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

class Preferences {
    let defaults = UserDefaults.standard
    
    //MARK: - Exists preferences
    
    func existPreferences(data: String) -> Bool {
        return defaults.object(forKey: data) != nil
    }
    
    //MARK: - Preferences
    
    func savePreferences(value: Int, key: String) {
        defaults.set(value, forKey: key)
    }
    
    func getPreferences(key: String) -> Int {
        guard defaults.object(forKey: key) != nil else { return 0 }
        return defaults.object(forKey: key) as! Int
    }
    
    func savePreferences(value: Int32, key: String) {
        defaults.set(value, forKey: key)
    }
    
    func getPreferences(key: String) -> Int32 {
        guard defaults.object(forKey: key) != nil else { return 0 }
        return defaults.object(forKey: key) as! Int32
    }
    
    //MARK: - SUM
    
    func addSum(spent: Double) {
        if defaults.object(forKey: "sum") != nil {
            let sum = defaults.object(forKey: "sum") as! Double
            let total = sum + spent
            defaults.set(total, forKey: "sum")
        } else {
            defaults.set(spent, forKey: "sum")
        }
    }
    
    func displaySum() -> Double {
        let sum = defaults.object(forKey: "sum")
        guard sum != nil else { return 0.0 }
        return sum as! Double
    }
    
    func resetSum() {
        defaults.set(0.0, forKey: "sum")
    }
    
    func saveSum(spent: Double) {
        defaults.set(spent, forKey: "sum")
    }
}
