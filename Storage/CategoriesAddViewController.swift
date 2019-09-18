//
//  CategoryAdd.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 04/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoriesAddViewController: UIViewController {
    
    weak var delegate: CategoriesAddViewControllerDelegate?
    
    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var confirmeButton: UIButton!
    @IBOutlet weak var nameCategoryTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameCategoryTextField.becomeFirstResponder()
        nameCategoryTextField.border()
    }
    
    @IBAction func addCategory() {
        delegate?.addCategory(nameCategoryTextField.text?.removingEndingSpaces())
        nameCategoryTextField.text = ""
    }
    
    @IBAction func close() {
        nameCategoryTextField.resignFirstResponder()
        remove()
        delegate?.removeChildSettings()
    }
    
}
