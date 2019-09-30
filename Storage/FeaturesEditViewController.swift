//
//  FeaturesEditView.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 13/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class FeaturesEditViewController: UIViewController {
    
    weak var delegate: FeaturesEditViewControllerDelegate?

    @IBOutlet weak var textFieldBackView: UIView!
    @IBOutlet weak var editTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldBackView.borderInactive()
        delegate?.featuresTableViewEditing()
        editTextField.delegate = self
        confirmButton.isHidden = true
    }
    
    @IBAction func removeView() {
        editTextField.resignFirstResponder()
        delegate?.featuresTableViewEndEditing()
        remove()
        delegate?.newFeaturesSettingsViewController()
    }
    
    @IBAction func updateNameFeatures() {
        guard editTextField.text != "" else { return }
        let result: Bool = delegate?.editNameFeature(editTextField.text!) ?? false
        if result {
            editTextField.resignFirstResponder()
        }
    }
}

extension FeaturesEditViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return delegate?.featureSelected() != nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldBackView.borderFocus()
        confirmButton.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        editTextFieldEndEditing()
    }
}

protocol FeaturesEditTextFieldDelegate: AnyObject {
    func text(_ string: String)
    func editTextFieldEndEditing()
    func textFieldBackViewBorder(_ feature: Feature?)
}

extension FeaturesEditViewController: FeaturesEditTextFieldDelegate {
    func text(_ string: String) {
        editTextField.text = string
    }
    
    func editTextFieldEndEditing() {
        editTextField.resignFirstResponder()
        editTextField.text = ""
        textFieldBackView.borderInactive()
        confirmButton.isHidden = true
    }
    
    func textFieldBackViewBorder(_ feature: Feature?) {
        if editTextField.isFirstResponder {
            textFieldBackView.borderFocus()
        } else {
            if feature != nil {
                textFieldBackView.borderActive()
            } else {
                textFieldBackView.borderInactive()
            }
        }
    }
}
