//
//  SearchViewModel.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 20/11/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

struct SearchViewModel {
    
    weak var delegate: SearchViewDelegate?
    
    func researching(_ text: String) {
        delegate?.researching(text)
    }
    
    func textFieldDidResearching(_ text: String) {
        delegate?.textFieldDidResearching(text)
    }
    
    func removeSearch() {
        delegate?.removeSearch()
    }
    
    func newChildSettings() {
        delegate?.newChildSettings()
    }
}
