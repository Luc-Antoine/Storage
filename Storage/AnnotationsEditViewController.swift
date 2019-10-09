//
//  AnnotationsEditViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 30/09/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class AnnotationsEditViewController: UIViewController {

    weak var delegate: AnnotationsEditViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate?.annotationsTableViewEditing()
    }
    
    @IBAction func removeView() {
        remove()
        delegate?.newChildSettings()
    }
}
