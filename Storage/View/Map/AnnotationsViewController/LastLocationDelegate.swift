//
//  LastLocationDelegate.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 27/11/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

protocol LastLocationDelegate: AnyObject {
    func lastLocation(_ position: Position)
}
