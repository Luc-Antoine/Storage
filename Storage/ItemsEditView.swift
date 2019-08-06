//
//  ItemsEditView.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 22/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class ItemsEditView: UIView {
    
    var controller: ItemsController?
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var editTexrField: UITextField!
    
    @IBAction func removeView() {
        editTexrField.resignFirstResponder()
//        controller?.categoriesTableViewEndEditing()
        controller?.removeSettingsContainer()
        controller?.instantiateItemsSettingsController()
    }
    
    @IBAction func textFieldChanged(_ sender: Any) {
        guard editTexrField.text != nil else { return }
//        controller?.textFieldDidResearching(editTexrField.text!)
    }
    
}
