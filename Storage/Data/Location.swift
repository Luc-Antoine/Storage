//
//  Location.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 22/03/2017.
//  Copyright © 2017 Luc-Antoine Dupont. All rights reserved.
//

import Foundation
import CoreLocation

class Location: NSObject, CLLocationManagerDelegate {
    var currentLocation: CLLocation? = nil
    var showUserLocation: Bool?
    var isAuthorised = false {
        didSet {
            if isAuthorised {
                locationManager.startUpdatingLocation()
                showUserLocation = true
            } else {
                locationManager.stopUpdatingLocation()
                currentLocation = nil
                showUserLocation = false
            }
        }
    }
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        isAuthorised = (status == .authorizedWhenInUse)
    }
    
    func distance(of position: Position) -> CLLocationDistance {
        let location = CLLocation(latitude: position.lat, longitude: position.lng)
        return currentLocation?.distance(from: location) ?? Double.infinity
    }
}

extension CLLocationCoordinate2D {
    var position: Position {
        return Position(lat: latitude, lng: longitude)
    }
}
