//
//  AnnotationsViewModel.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 27/11/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

struct AnnotationsViewModel {
    
    private let lastLocation = LastLocation()
    
    func distanceFormatted(lat: Double, lng: Double) -> String {
        return lastLocation.calculateDistance(position: Position(lat: lat, lng: lng))
    }
    
    func lastLocationDelegate(_ delegate: AnnotationsViewController) {
        lastLocation.delegate = delegate
    }
}
