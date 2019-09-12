//
//  ItemsAddView.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 22/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class ItemsAddViewController: UIViewController {
    
    weak var delegate: ItemsAddViewControllerDelegate?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var confirmeButton: UIButton!
    @IBOutlet weak var nameItemTextField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nameItemTextField.becomeFirstResponder()
        nameItemTextField.border()
    }
    
    @IBAction func addItem() {
        delegate?.addItem(nameItemTextField.text?.removingEndingSpaces())
        nameItemTextField.text = ""
    }
    
    @IBAction func removeView() {
        nameItemTextField.resignFirstResponder()
        remove()
        delegate?.removeChildSettings()
    }
}
