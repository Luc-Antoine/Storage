//
//  SettingsViewModel.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 23/11/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

struct SettingsViewModel {
    
    weak var delegate: SettingsViewDelegate?
    
    func navigationSettings(_ index: Int) {
        delegate?.navigationSettings(index)
    }
}
