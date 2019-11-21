//
//  EditViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 21/11/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    
    weak var delegate: CategoriesEditViewControllerDelegate?

    @IBOutlet weak var textFieldBackView: UIView!
    @IBOutlet weak var editTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldBackView.borderInactive()
        delegate?.categoryTableViewEditing()
        editTextField.delegate = self
        confirmButton.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeSelf()
    }
    
    @IBAction func removeView() {
        removeSelf()
    }
    
    @IBAction func updateNameCategory() {
        guard editTextField.text != "" else { return }
        let result: Bool = delegate?.editNameCategory(editTextField.text!) ?? false
        if result {
            editTextField.resignFirstResponder()
        }
    }
    
    private func removeSelf() {
        editTextField.resignFirstResponder()
        remove()
        delegate?.newChildSettings()
    }
}

// MARK: - UITextFieldDelegate

extension EditViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return delegate?.categorySelected() != nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldBackView.borderFocus()
        confirmButton.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        editTextFieldEndEditing()
    }
}

// MARK: - CategoriesEditTextFieldDelegate

protocol EditDelegate: AnyObject {
    func text(_ string: String)
    func editTextFieldEndEditing()
    func textFieldBackViewBorder(_ category: Category?)
}

extension EditViewController: EditDelegate {
    
    func text(_ string: String) {
        editTextField.text = string
    }
    
    func editTextFieldEndEditing() {
        editTextField.resignFirstResponder()
        editTextField.text = ""
        textFieldBackView.borderInactive()
        confirmButton.isHidden = true
    }
    
    func textFieldBackViewBorder(_ category: Category?) {
        if editTextField.isFirstResponder {
            textFieldBackView.borderFocus()
        } else {
            if category != nil {
                textFieldBackView.borderActive()
            } else {
                textFieldBackView.borderInactive()
            }
        }
    }
}
