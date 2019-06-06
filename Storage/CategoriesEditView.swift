//
//  CategoriesEdit.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 02/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoriesEditView: UIView {
    
    var controller: CategoriesController?
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var editTexrField: UITextField!
    
    @IBAction func removeView() {
        editTexrField.resignFirstResponder()
        controller?.categoriesTableViewEndEditing()
        controller?.removeSettingsContainer()
        controller?.instantiateCategoriesSettingsView()
    }
    
    @IBAction func textFieldChanged(_ sender: Any) {
        guard editTexrField.text != nil else { return }
        controller?.textFieldDidResearching(editTexrField.text!)
    }
}
