//
//  ItemsSettingsView.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 22/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class ItemsSettingsView: UIView {
    
    var controller: ItemsController?
    var settingsController: ItemsSettingsController?
    
    var settingSegmentedIndex: Int = 3
    
    @IBOutlet weak var settings: UISegmentedControl!
    
    @IBAction func settingsDisplay(_ sender: Any) {
        settingSegmentedIndex = settings.selectedSegmentIndex
        switch settings.selectedSegmentIndex {
        case 0:
            controller?.removeSettingsContainer()
            settingsController?.instantiateEditView()
            settings.selectedSegmentIndex = UISegmentedControl.noSegment
//            controller?.categoriesTableViewEditing()
            break
        case 1:
            controller?.removeSettingsContainer()
            settingsController?.instantiateSortView()
            settings.selectedSegmentIndex = UISegmentedControl.noSegment
            break
        case 2:
            controller?.removeSettingsContainer()
            settingsController?.instantiateSearchView()
            settings.selectedSegmentIndex = UISegmentedControl.noSegment
            break
        case 3:
            controller?.removeSettingsContainer()
            settingsController?.instantiateSearchView()
            settings.selectedSegmentIndex = UISegmentedControl.noSegment
            break
        default:
            break
        }
    }
    
}
