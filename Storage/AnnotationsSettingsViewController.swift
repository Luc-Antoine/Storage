//
//  AnnotationsSettingsViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 30/09/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class AnnotationsSettingsViewController: UIViewController {

    weak var delegate: AnnotationsSettingsViewControllerDelegate?
    
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
