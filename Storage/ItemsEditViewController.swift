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
    
    @IBOutlet weak var textFieldBackView: UIView!
    @IBOutlet weak var editTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldBackView.borderInactive()
        delegate?.itemsTableViewEditing()
        editTextField.delegate = self
        confirmButton.isHidden = true
    }
    
    @IBAction func removeView() {
        editTextField.resignFirstResponder()
        delegate?.itemsTableViewEndEditing()
        remove()
        delegate?.newChildSettings()
    }
    
    @IBAction func updateNameFeatures() {
        guard editTextField.text != "" else { return }
        let result: Bool = delegate?.editNameItem(editTextField.text!) ?? false
        if result {
            editTextField.resignFirstResponder()
        }
    }
}

// MARK: - UITextFieldDelegate

extension ItemsEditViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return delegate?.itemSelected() != nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldBackView.borderFocus()
        confirmButton.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        editTextFieldEndEditing()
    }
}

// MARK: - ItemsEditTextFieldDelegate

protocol ItemsEditTextFieldDelegate: AnyObject {
    func text(_ string: String)
    func editTextFieldEndEditing()
    func textFieldBackViewBorder(_ item: Item?)
}

extension ItemsEditViewController: ItemsEditTextFieldDelegate {
    func text(_ string: String) {
        editTextField.text = string
    }
    
    func editTextFieldEndEditing() {
        editTextField.resignFirstResponder()
        editTextField.text = ""
        textFieldBackView.borderInactive()
        confirmButton.isHidden = true
    }
    
    func textFieldBackViewBorder(_ item: Item?) {
        if editTextField.isFirstResponder {
            textFieldBackView.borderFocus()
        } else {
            if item != nil {
                textFieldBackView.borderActive()
            } else {
                textFieldBackView.borderInactive()
            }
        }
    }
}
