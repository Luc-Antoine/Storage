//
//  File.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 20/11/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

protocol SortViewDelegate: AnyObject {
    func newChildSettings()
    func newSort(_ sort: Sort)
}
