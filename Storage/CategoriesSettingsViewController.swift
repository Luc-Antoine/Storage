//
//  CategorySettingsController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 02/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoriesSettingsViewController: UIViewController {
    
    weak var delegate: CategoriesSettingsViewControllerDelegate?
    
    var searchCount: Int = 0
    
    @IBOutlet weak var settings: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard searchCount > 0 else { return }
        settings.setTitle(NSLocalizedString("Search", comment: "") + " (\(searchCount))", forSegmentAt: 2)
    }
    
    @IBAction func settingsDisplay(_ sender: Any) {
        remove()
        delegate?.navigationSettings(settings.selectedSegmentIndex)
    }
    
}
