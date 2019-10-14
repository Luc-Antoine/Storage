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
    
    @IBOutlet weak var bunttonsView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bunttonsView.borderFocus()
        bunttonsView.clipsToBounds = true
        
        guard searchCount > 0 else { return }
        searchButton.backgroundColor = UIColor.mainColor
        searchButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    @IBAction func modify() {
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
