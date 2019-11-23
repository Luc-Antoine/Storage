//
//  AddViewModel.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 20/11/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

struct AddViewModel {
    
    weak var delegate: AddViewDelegate?
    
    func add(_ name: String) {
        delegate?.add(name)
    }
    
    func newChildSettings() {
        delegate?.newChildSettings()
    }
    
}
