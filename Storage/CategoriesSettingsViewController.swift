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
    
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonsView.borderFocus()
        buttonsView.clipsToBounds = true
        guard searchCount > 0 else { return }
        searchButton.backgroundColor = UIColor.mainColor
        searchButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    @IBAction func edit() {
        remove()
        delegate?.navigationSettings(0)
    }
    
    @IBAction func sort() {
        remove()
        delegate?.navigationSettings(1)
    }
    
    @IBAction func search() {
        remove()
        delegate?.navigationSettings(2)
    }
}
