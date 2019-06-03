//
//  CategorySort.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 02/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategorySort: UIView {
    
    var controller: CategoryController?
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    
    @IBAction func removeView() {
        controller?.removeSettingsContainer()
        controller?.instantiateCategorySettings()
    }
    
}
