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
    
    // MARK: - Data Base
    
    func dataBaseCreated(_ value: Bool) {
        defaults.set(value, forKey: "dataBaseCreated")
    }
    
    func dataBaseCreated() -> Bool {
        return defaults.object(forKey: "dataBaseCreated") as? Bool ?? false
    }
    
    func lastFeatureId(_ value: Int) {
        defaults.set(value + 1, forKey: "lastFeatureId")
    }
    
    func lastFeatureId() -> Int {
        return defaults.object(forKey: "lastFeatureId") as! Int
    }
    
    // MARK: - Position
    
    func lastLocation(_ value: Position) {
        defaults.set(value.lat, forKey: "latitude")
        defaults.set(value.lng, forKey: "longitude")
        print("Last position updated !")
    }
    
//    func lastLocation() -> Position {
//        let latitude: Double = defaults.object(forKey: "latitude") as! Double
//        let longitude: Double = defaults.object(forKey: "longitude") as! Double
//        return Position(lat: latitude, lng: longitude)
////        return defaults.object(forKey: "lastLocation") as! Position
//    }
    
    // MARK: - Sort
    
    func categorySort(_ value: Int) {
        defaults.set(value, forKey: "categorySort")
    }
    
    func categorySort() -> Int {
        return defaults.object(forKey: "categorySort") as! Int
    }
    
    func itemSort(_ value: Int) {
        defaults.set(value, forKey: "itemSort")
    }
    
    func itemSort() -> Int {
        return defaults.object(forKey: "itemSort") as! Int
    }
    
    func annotationSort(_ value: Int) {
        defaults.set(value, forKey: "annotationSort")
    }
    
    func annotationSort() -> Int {
        return defaults.object(forKey: "annotationSort") as! Int
    }
}
