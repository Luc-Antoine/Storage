//
//  EditViewDelegate.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 21/11/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

protocol EditViewDelegate: AnyObject {
    func tableViewEditing()
    func editNameObject(_ name: String) -> Bool
    func newChildSettings()
    func objectSelected() -> Bool
}

extension EditViewDelegate {
    func textFieldDidResearching(_ text: String) {}
    func tableViewEndEditing() {}
}
