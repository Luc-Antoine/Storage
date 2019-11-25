//
//  EditViewModel.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 21/11/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

struct EditViewModel {
    weak var delegate: EditViewDelegate?
    
    func categoryTableViewEditing() {
        delegate?.tableViewEditing()
    }
    
    func editNameCategory(_ name: String) -> Bool {
        return delegate?.editNameObject(name) ?? false
    }
    
    func textFieldDidResearching(_ text: String) {
        delegate?.textFieldDidResearching(text)
    }
    
    func newChildSettings() {
        delegate?.newChildSettings()
    }
    
    func objectSelected() -> Bool {
        return delegate?.objectSelected() ?? false
    }
}
