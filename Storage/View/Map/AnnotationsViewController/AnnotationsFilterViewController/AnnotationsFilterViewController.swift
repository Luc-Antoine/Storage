//
//  AnnotationsFilterViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 28/11/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class AnnotationsFilterViewController: UIViewController {

    weak var delegate: AnnotationsFilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonsView.borderFocus()
        buttonsView.clipsToBounds = true
    }
    
    @IBOutlet weak var buttonsView: UIView!
    
    @IBAction func confirm() {
        delegate?.filters()
        remove()
        delegate?.newChildSettings()
    }
    
    @IBAction func cancelFilter() {
        delegate?.resetFilters()
        remove()
        delegate?.newChildSettings()
    }
}
