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
    
    var filterCount: Int = 0
    
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var filterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonsView.borderFocus()
        buttonsView.clipsToBounds = true
        guard filterCount > 0 else { return }
        filterButton.backgroundColor = UIColor.mainColor
        filterButton.setTitleColor(UIColor.white, for: .normal)
        if Locale.current.languageCode == "fr" {
            if filterCount > 1 {
                filterButton.setTitle("\(filterCount) Filtres", for: .normal)
            } else {
                filterButton.setTitle("\(filterCount) Filtre", for: .normal)
            }
        } else {
            filterButton.setTitle("\(filterCount) " + NSLocalizedString("Filter", comment: ""), for: .normal)
        }
    }
    
    @IBAction func edit() {
        remove()
        delegate?.navigationSettings(0)
    }
    
    @IBAction func sort() {
        remove()
        delegate?.navigationSettings(1)
    }
    
    @IBAction func filter() {
        remove()
        delegate?.navigationSettings(2)
    }
}
