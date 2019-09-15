//
//  ItemsSettingsView.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 22/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class ItemsSettingsViewController: UIViewController {
    
    weak var delegate: ItemsSettingsViewControllerDelegate?
    
    @IBOutlet weak var settings: UISegmentedControl!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        settings.setTitle(delegate?.filterTitle(), forSegmentAt: 3)
    }
    
    @IBAction func settingsDisplay(_ sender: Any) {
        remove()
        delegate?.navigationSettings(settings.selectedSegmentIndex)
    }
}
