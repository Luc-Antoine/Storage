//
//  CategoriesEdit.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 02/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoriesEditView: UIView {
    
    weak var controller: CategoriesController?
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var editTextField: UITextField!
    
    @IBAction func removeView() {
        editTextField.resignFirstResponder()
        controller?.categoriesTableViewEndEditing()
        controller?.removeSettingsContainer()
        controller?.instantiateCategoriesSettingsView()
    }
    
    @IBAction func textFieldChanged(_ sender: Any) {
        guard editTextField.text != nil else { return }
        controller?.textFieldDidResearching(editTextField.text!)
    }
    
    func viewDidAppear() {
        editTextField.delegate = controller!.categoriesTableViewController
        editTextField.borderDesign()
    }
}
