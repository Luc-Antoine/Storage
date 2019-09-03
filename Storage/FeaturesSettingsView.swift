//
//  FeaturesSettingsView.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 13/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class FeaturesSettingsView: UIView {
    
    var controller: FeaturesController?
    
    @IBOutlet weak var editButton: UIButton!
    
    func viewDidAppear() {
        design()
    }
    
    @IBAction func insdtantiateEditView() {
        controller!.instantiateFeaturesEditView()
    }
    
    private func design() {
        editButton.border()
    }


}
