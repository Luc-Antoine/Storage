//
//  AnnotationsViewModelDelegate.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 27/11/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

protocol AnnotationsViewModelDelegate: AnyObject {
    func distance(_ of: Double) -> String
}
