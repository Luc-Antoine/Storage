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
    
    var settingSegmentedIndex: Int = 3
    
    @IBOutlet weak var settings: UISegmentedControl!
    
    func viewDidAppear() {
        let filters: Int = controller!.featuresFilteredByItem.count
        guard filters > 0 else { return }
        settings.setTitle(NSLocalizedString("Filter", comment: "") + "(\(filters))", forSegmentAt: 3)
    }
    
    @IBAction func settingsDisplay(_ sender: Any) {
        settingSegmentedIndex = settings.selectedSegmentIndex
        switch settings.selectedSegmentIndex {
        case 0:
            controller?.removeSettingsContainer()
            controller?.instantiateEditView()
            settings.selectedSegmentIndex = UISegmentedControl.noSegment
//            controller?.categoriesTableViewEditing()
            break
        case 1:
            controller?.removeSettingsContainer()
            controller?.instantiateSortView()
            settings.selectedSegmentIndex = UISegmentedControl.noSegment
            break
        case 2:
            controller?.removeSettingsContainer()
            controller?.instantiateSearchView()
            settings.selectedSegmentIndex = UISegmentedControl.noSegment
            break
        case 3:
            controller?.removeSettingsContainer()
            controller?.instantiateFilterView()
            settings.selectedSegmentIndex = UISegmentedControl.noSegment
            break
        default:
            break
        }
    }
    
}
