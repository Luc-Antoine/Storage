//
//  CategoriesSearch.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 02/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoriesSearchView: UIView {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    var controller: CategoriesController?
    
    @IBAction func removeView() {
        searchTextField.resignFirstResponder()
        controller?.categoriesTableViewEndEditing()
        controller?.removeSettingsContainer()
        controller?.instantiateCategoriesSettingsView()
    }
    
    @IBAction func textFieldChanged(_ sender: Any) {
        guard searchTextField.text != nil else { return }
        controller?.textFieldDidResearching(searchTextField.text!)
    }
}
