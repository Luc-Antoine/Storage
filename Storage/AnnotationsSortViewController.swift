//
//  AnnotationsSortViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 30/09/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class AnnotationsSortViewController: UIViewController {

    weak var delegate: AnnotationsSortViewControllerDelegate?
    
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortSegmentedControl.selectedSegmentIndex = delegate?.annotationsSortIndex()?.rawValue ?? 0
    }
    
    @IBAction func removeView() {
        remove()
        delegate?.newChildSettings()
    }
    
    @IBAction func sortChoice() {
        delegate?.sortChoice(Sort.init(rawValue: sortSegmentedControl.selectedSegmentIndex)!)
        
    }
}
