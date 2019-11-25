//
//  FeaturesSettingsView.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 13/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class FeaturesSettingsViewController: UIViewController {
    
    weak var delegate: FeaturesSettingsViewControllerDelegate?
    
    @IBOutlet weak var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        design()
    }
    
    @IBAction func instantiateEditView() {
        remove()
        delegate?.newFeaturesEditViewController()
    }
    
    private func design() {
        editButton.border()
    }
}
