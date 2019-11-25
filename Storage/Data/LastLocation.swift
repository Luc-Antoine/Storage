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
    
    var annotationsTableViewControllerLocationDelegate: AnnotationsTableViewControllerLocationDelegate?
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        annotationsTableViewDelegate(Position(lat: currentLocation!.coordinate.latitude, lng: currentLocation!.coordinate.longitude))
        locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        isAuthorised = (status == .authorizedWhenInUse)
    }
    
    func calculateDistance(position: Position) -> String {
        let numberFormatter = NumberFormatter()
        var unit: String = ""
        var number: NSNumber = 0
        numberFormatter.maximumFractionDigits = 0
        let distance = self.distance(of: position)
        if distance >= 1000 {
            number = NSNumber(floatLiteral: distance / 1000)
            unit = " km"
        } else {
            number = NSNumber(floatLiteral: distance)
            unit = " m"
        }
        return numberFormatter.string(from: number)! + unit
    }
    
    // MARK: - Location Delegates
    
    private func annotationsTableViewDelegate(_ position: Position) {
        annotationsTableViewControllerLocationDelegate?.reloadCurrentLocation(position)
    }
    
    private func distance(of position: Position) -> CLLocationDistance {
        let location = CLLocation(latitude: position.lat, longitude: position.lng)
        return currentLocation?.distance(from: location) ?? Double.infinity
    }
}
