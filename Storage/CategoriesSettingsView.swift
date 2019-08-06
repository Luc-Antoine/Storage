//
//  CategorySettingsController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 02/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoriesSettingsView: UIView {
    
    weak var controller: CategoriesController?
    
    var settingSegmentedIndex: Int = 3
    
    @IBOutlet weak var settings: UISegmentedControl!
    
    @IBAction func settingsDisplay(_ sender: Any) {
        settingSegmentedIndex = settings.selectedSegmentIndex
        switch settings.selectedSegmentIndex {
        case 0:
            controller?.removeSettingsContainer()
            controller?.instantiateCategoriesEditView()
            settings.selectedSegmentIndex = UISegmentedControl.noSegment
            controller?.categoriesTableViewEditing()
            break
        case 1:
            controller?.removeSettingsContainer()
            controller?.instantiateCategoriesSortView()
            settings.selectedSegmentIndex = UISegmentedControl.noSegment
            break
        case 2:
            controller?.removeSettingsContainer()
            controller?.instantiateCategoriesSearchView()
            settings.selectedSegmentIndex = UISegmentedControl.noSegment
            break
        default:
            break
        }
    }
    
}
