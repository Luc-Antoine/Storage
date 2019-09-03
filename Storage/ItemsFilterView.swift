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
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var validateButton: UIButton!
    
    @IBAction func confirm() {
        guard controller!.nameFeaturesFiltered.count > 0 else { return }
        controller!.filters()
    }
    
    @IBAction func removeView() {
        controller!.resetFilters()
        controller!.removeSettingsContainer()
        controller!.instantiateItemsSettingsView()
    }
    
    func viewDidAppear() {
        cancelButton.border()
        validateButton.border()
    }
}
