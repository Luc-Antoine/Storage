//
//  ItemsFilterView.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 02/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class ItemsFilterView: UIView {
    
    var controller: ItemsController?
    
    @IBOutlet weak var filterTextField: UITextField!
    
    @IBAction func removeView() {
        controller?.removeSettingsContainer()
        controller?.instantiateItemsSettingsController()
    }
}
