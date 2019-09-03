//
//  ItemsSearchView.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 22/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class ItemsSearchView: UIView {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    var controller: ItemsController?
    
    @IBAction func removeView() {
        searchTextField.resignFirstResponder()
        controller?.textFieldDidEndEditing()
        controller?.itemsTableViewEndEditing()
        controller?.removeSettingsContainer()
        controller?.instantiateItemsSettingsView()
    }
    
    @IBAction func textFieldChanged() {
        guard searchTextField.text != nil else { return }
        controller?.textFieldDidResearching(searchTextField.text!)
    }
    
    func viewDidAppear() {
        searchTextField.border()
        searchTextField.paddingLeft()
        searchTextField.becomeFirstResponder()
        controller?.textFieldDidBeginEditing()
    }
    
}
