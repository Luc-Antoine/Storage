//
//  AnnotationsEditViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 30/09/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class AnnotationsEditViewController: UIViewController {

    weak var delegate: AnnotationsEditViewControllerDelegate?
    
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
        remove()
        delegate?.newChildSettings()
    }
    
    @IBAction func textFieldChanged() {
        guard editTextField.text != nil else { return }
        delegate?.textFieldDidResearching(editTextField.text!)
    }
    
    @IBAction func updateNameAnnotation() {
        guard editTextField.text != "" else { return }
        let result: Bool = delegate?.editNameAnnotation(editTextField.text!) ?? false
        if result {
            editTextField.resignFirstResponder()
        }
    }

}

// MARK: - UITextFieldDelegate

extension AnnotationsEditViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return delegate?.annotationSelected() != nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldBackView.borderFocus()
        confirmButton.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        editTextFieldEndEditing()
    }
}

// MARK: - AnnotationsEditTextFieldDelegate

protocol AnnotationsEditDelegate: AnyObject {
    func text(_ string: String)
    func editTextFieldEndEditing()
    func textFieldBackViewBorder(_ annotation: Annotation?)
}

extension AnnotationsEditViewController: AnnotationsEditDelegate {
    
    func text(_ string: String) {
        editTextField.text = string
    }
    
    func editTextFieldEndEditing() {
        editTextField.resignFirstResponder()
        editTextField.text = ""
        textFieldBackView.borderInactive()
        confirmButton.isHidden = true
    }
    
    func textFieldBackViewBorder(_ annotation: Annotation?) {
        if editTextField.isFirstResponder {
            textFieldBackView.borderFocus()
        } else {
            if annotation != nil {
                textFieldBackView.borderActive()
            } else {
                textFieldBackView.borderInactive()
            }
        }
    }
}
