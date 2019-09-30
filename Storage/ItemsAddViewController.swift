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
    
    @IBOutlet weak var textFieldBackView: UIView!
    @IBOutlet weak var confirmeButton: UIButton!
    @IBOutlet weak var nameItemTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldBackView.borderFocus()
        nameItemTextField.becomeFirstResponder()
    }
    
    @IBAction func addItem() {
        delegate?.addItem(nameItemTextField.text?.removingEndingSpaces())
        nameItemTextField.text = ""
    }
    
    @IBAction func removeView() {
        nameItemTextField.resignFirstResponder()
        remove()
        delegate?.newChildSettings()
    }
}
