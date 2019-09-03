//
//  CategoryAdd.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 04/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoriesAddView: UIView {
    
    weak var controller: CategoriesController?
    
    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var confirmeButton: UIButton!
    @IBOutlet weak var nameCategoryTextField: UITextField!
    
    @IBAction func removeView() {
        nameCategoryTextField.resignFirstResponder()
        controller!.removeSettingsContainer()
        controller!.instantiateCategoriesSettingsView()
    }
    
    @IBAction func addCategory() {
        let newCategoryName = nameCategoryTextField.text?.removingEndingSpaces()
        guard newCategoryName != "" else { return }
        controller?.addCategory(newCategoryName: newCategoryName!)
        nameCategoryTextField.text = ""
    }
    
    func viewDidAppear() {
        nameCategoryTextField.becomeFirstResponder()
        nameCategoryTextField.border()
    }
    
}
