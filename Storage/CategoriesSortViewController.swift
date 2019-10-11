//
//  CategoriesSort.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 02/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoriesSortViewController: UIViewController {
    
    weak var delegate: CategoriesSortViewControllerDelegate?
    
    @IBOutlet weak var closeButton: UIButton!
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
