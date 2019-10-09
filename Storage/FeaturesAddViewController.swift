//
//  FeaturesAddView.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 13/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class FeaturesAddViewController: UIViewController {
    
    weak var delegate: FeaturesAddViewControllerDelegate?
    
    @IBOutlet weak var textFieldBackView: UIView!
    @IBOutlet weak var editTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldBackView.borderFocus()
        editTextField.becomeFirstResponder()
    }
    
    @IBAction func removeView() {
        editTextField.resignFirstResponder()
        remove()
        delegate?.newFeaturesSettingsViewController()
    }
    
    @IBAction func add() {
        guard editTextField.text != "" else { return }
        delegate?.add(editTextField.text!.removingEndingSpaces())
        editTextField.text = ""
    }
}
