//
//  FeaturesAddView.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 13/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class FeaturesAddView: UIView {
    
    var controller: FeaturesController?
    
    @IBOutlet weak var editTextField: UITextField!
    
    @IBAction func removeView() {
        //controller!.isEditing = false
        editTextField.resignFirstResponder()
        controller?.removeSettingsContainer()
        controller?.instantiateFeaturesSettingsView()
    }
    
    @IBAction func add() {
        guard editTextField.text != "" else { return }
        controller!.add(NameFeature(id: 0, name: editTextField.text!.removingEndingSpaces(), categoryId: controller!.category!.id))
        editTextField.text = ""
    }
    
    func viewDidAppear() {
        editTextField.border()
        editTextField.paddingLeft()
        editTextField.becomeFirstResponder()
    }

}
