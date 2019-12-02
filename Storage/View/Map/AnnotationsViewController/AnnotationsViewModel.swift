//
//  AnnotationsViewModel.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 27/11/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

struct AnnotationsViewModel {
    
    var lastLocation: LastLocation?
    
    func distance(_ of: Double) -> String {
        return formatter(of)
    }
    
    func formatter(_ value: Double) -> String {
        let formatter = MeasurementFormatter()
        formatter.locale = NSLocale.current
        formatter.unitOptions = .naturalScale
        
        if value < 1000 {
            let distance: Double = (value.rounded() / 1000)
            let measurement = Measurement(value: distance, unit: UnitLength.kilometers)
            return formatter.string(from: measurement)
        } else {
            let distance: Double = (value / 1000).rounded()
            let measurement = Measurement(value: distance, unit: UnitLength.kilometers)
            return formatter.string(from: measurement)
        }
    }
}
