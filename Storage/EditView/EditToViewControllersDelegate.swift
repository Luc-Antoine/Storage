//
//  EditToViewControllersDelegate.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 24/11/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

protocol EditToViewControllersDelegate: AnyObject {
    func text(_ string: String)
    func editTextFieldEndEditing()
    func textFieldBackViewBorder(_ bool: Bool)
}
