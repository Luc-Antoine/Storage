//
//  AddViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 20/11/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    var viewModel: AddViewModel?
    
    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var textFieldBackView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var confirmeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.becomeFirstResponder()
        textFieldBackView.borderFocus()
    }
    
    @IBAction func add() {
        guard nameTextField.text != nil else { return }
        guard nameTextField.text != "" else { return }
        viewModel?.add(nameTextField.text!.removingEndingSpaces())
        nameTextField.text = ""
    }
    
    @IBAction func close() {
        nameTextField.resignFirstResponder()
        remove()
        viewModel?.newChildSettings()
    }
}
