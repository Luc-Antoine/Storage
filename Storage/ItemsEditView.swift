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
        //controller!.isEditing = false
        editTexrField.resignFirstResponder()
        controller?.itemsTableViewEndEditing()
        controller?.removeSettingsContainer()
        controller?.instantiateItemsSettingsView()
    }
    
    @IBAction func textFieldChanged() {
        guard editTexrField.text != nil else { return }
        controller?.textFieldDidResearching(editTexrField.text!)
    }
    
    func viewDidAppear() {
        //controller!.isEditing = true
        controller!.itemsTableViewEditing()
        editTexrField.border()
        editTexrField.paddingLeft()
    }
    
}
