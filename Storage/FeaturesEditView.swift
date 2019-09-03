//
//  FeaturesEditView.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 13/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class FeaturesEditView: UIView {
    
    var controller: FeaturesController?

    @IBOutlet weak var editTextField: UITextField!
    
    @IBAction func removeView() {
        editTextField.resignFirstResponder()
        controller!.featuresTableViewEndEditing()
        controller?.removeSettingsContainer()
        controller?.instantiateFeaturesSettingsView()
    }
    
    @IBAction func updateNameFeatures() {
        guard editTextField.text != "" else { return }
        controller!.edit(editTextField.text!)
    }
    
    func viewDidAppear() {
        editTextField.border()
        editTextField.paddingLeft()
        controller!.featuresTableViewEditing()
    }

}
