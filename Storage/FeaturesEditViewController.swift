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
    
    var controller: FeaturesController?

    @IBOutlet weak var editTextField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        editTextField.border()
        editTextField.paddingLeft()
        delegate?.featuresTableViewEditing()
    }
    
    @IBAction func removeView() {
        editTextField.resignFirstResponder()
        delegate?.featuresTableViewEndEditing()
        remove()
        delegate?.newFeaturesSettingsViewController()
    }
    
    @IBAction func updateNameFeatures() {
        guard editTextField.text != "" else { return }
        delegate?.editNameFeature(editTextField.text!)
    }

}

protocol FeaturesEditTextFieldDelegate: AnyObject {
    func text(_ string: String)
}

extension FeaturesEditViewController: FeaturesEditTextFieldDelegate {
    func text(_ string: String) {
        editTextField.text = string
    }
}
