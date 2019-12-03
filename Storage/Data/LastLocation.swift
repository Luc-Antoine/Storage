//
//  LastLocation.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 06/10/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation
import CoreLocation

class LastLocation: NSObject, CLLocationManagerDelegate {
    
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
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        isAuthorised = (status == .authorizedWhenInUse)
    }
    
    func updateLastLocation(_ position: Position) {
        currentLocation = CLLocation(latitude: position.lat, longitude: position.lng)
    }
    
    // MARK: - Distance Function
    
    func distance(of position: Position) -> CLLocationDistance {
        let location = CLLocation(latitude: position.lat, longitude: position.lng)
        return currentLocation?.distance(from: location) ?? Double.infinity
    }
}
