//
//  ItemsSortView.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 22/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class ItemsSortViewController: UIViewController {
    
    weak var delegate: ItemsSortViewControllerDelegate?
    
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortSegmentedControl.font()
        sortSegmentedControl.selectedSegmentIndex = delegate?.categoriesSortIndex()?.rawValue ?? 0
    }
    
    @IBAction func removeView() {
        remove()
        delegate?.newChildSettings()
    }
    
    @IBAction func sortChoice() {
        delegate?.sortChoice(Sort.init(rawValue: sortSegmentedControl.selectedSegmentIndex)!)
    }
}
