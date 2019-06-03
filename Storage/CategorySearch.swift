//
//  CategorySearch.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 02/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategorySearch: UIView {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    var controller: CategoryController?
    
    @IBAction func removeView() {
        controller?.removeSettingsContainer()
        controller?.instantiateCategorySettings()
    }
    
}
