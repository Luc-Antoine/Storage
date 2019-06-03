//
//  CategorySettingsController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 02/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategorySettings: UIView {
    
    var controller: CategoryController?
    
    var settingSegmentedIndex: Int = 3
    
    @IBOutlet weak var settings: UISegmentedControl!
    
    @IBAction func settingsDisplay(_ sender: Any) {
        settingSegmentedIndex = settings.selectedSegmentIndex
        switch settings.selectedSegmentIndex {
        case 0:
            controller?.removeSettingsContainer()
            controller?.instantiateCategoryEdit()
            settings.selectedSegmentIndex = UISegmentedControl.noSegment
            controller?.categoryTableViewEditing()
            break
        case 1:
            controller?.removeSettingsContainer()
            controller?.instantiateCategorySort()
            settings.selectedSegmentIndex = UISegmentedControl.noSegment
            controller?.categoryTableViewSorting()
            break
        case 2:
            controller?.removeSettingsContainer()
            controller?.instantiateCategorySearch()
            settings.selectedSegmentIndex = UISegmentedControl.noSegment
            controller?.categoryTableViewSearching()
            break
        default:
            break
        }
    }
    
}
