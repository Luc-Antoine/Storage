//
//  ItemsAddView.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 22/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class ItemsAddView: UIView {
    
    var controller: ItemsController?
    
    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var confirmeButton: UIButton!
    @IBOutlet weak var nameCategoryTextField: UITextField!
    
    @IBAction func removeView() {
        nameCategoryTextField.resignFirstResponder()
        controller?.removeSettingsContainer()
        controller?.instantiateItemsSettingsController()
    }
    
    @IBAction func addItem() {
        let newCategoryName = nameCategoryTextField.text
        guard newCategoryName != "" else { return }
//        controller?.addCategory(newCategoryName: newCategoryName!)
        nameCategoryTextField.text = ""
    }
    
}
