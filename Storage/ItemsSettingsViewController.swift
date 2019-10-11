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
    
    var searchCount: Int = 0
    
    @IBOutlet weak var settings: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settings.setTitle(delegate?.filterTitle(), forSegmentAt: 3)
        settings.font()
//        guard searchCount > 0 else { return }
//        settings.setTitle(NSLocalizedString("Search", comment: "") + " (\(searchCount))", forSegmentAt: 2)
    }
    
    @IBAction func settingsDisplay(_ sender: Any) {
        remove()
        delegate?.navigationSettings(settings.selectedSegmentIndex)
    }
}
