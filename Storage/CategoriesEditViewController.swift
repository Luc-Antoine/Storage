//
//  CategoriesEdit.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 02/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoriesEditViewController: UIViewController {
    
    weak var delegate: CategoriesEditViewControllerDelegate?
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var editTextField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        editTextField.borderDesign()
    }
    
    @IBAction func removeView() {
        editTextField.resignFirstResponder()
        remove()
        delegate?.removeChildSettings()
    }
    
    @IBAction func textFieldChanged() {
        guard editTextField.text != nil else { return }
        delegate?.textFieldDidResearching(editTextField.text!)
    }
}
