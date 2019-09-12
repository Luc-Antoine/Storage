//
//  ItemsEditView.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 22/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class ItemsEditViewController: UIViewController {
    
    weak var delegate: ItemsEditViewControllerDelegate?
    
    var controller: ItemsController?
    
    @IBOutlet weak var editTexrField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        editTexrField.border()
        editTexrField.paddingLeft()
    }
    
    @IBAction func removeView() {
        editTexrField.resignFirstResponder()
        remove()
        delegate?.removeChildSettings()
    }
    
    @IBAction func textFieldChanged() {
        guard editTexrField.text != nil else { return }
        controller?.textFieldDidResearching(editTexrField.text!)
    }
}
