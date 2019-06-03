//
//  CategoryEdit.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 02/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoryEdit: UIView {
    
    var controller: CategoryController?
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var editTexrField: UITextField!
    
    @IBAction func removeView() {
        controller?.removeSettingsContainer()
        controller?.instantiateCategorySettings()
    }
}
