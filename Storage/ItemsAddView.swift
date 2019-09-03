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
        controller?.instantiateItemsSettingsView()
    }
    
    @IBAction func addItem() {
        let itemName = nameCategoryTextField.text?.removingEndingSpaces()
        guard itemName != "" else { return }
        controller!.add(itemName!)
        nameCategoryTextField.text = ""
    }
    
    func viewDidAppear() {
        nameCategoryTextField.border()
        nameCategoryTextField.paddingLeft()
        nameCategoryTextField.becomeFirstResponder()
    }
    
}
