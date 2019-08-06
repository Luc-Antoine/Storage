//
//  ItemsSettingsController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 23/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

class ItemsSettingsController {
    
    weak var itemsController: ItemsController?
    weak var itemsViewController: ItemsViewController?
    
    func instantiateItemsSettingsView(_ itemsViewController: ItemsViewController, itemsController: ItemsController) {
        self.itemsViewController = itemsViewController
        self.itemsController = itemsController
        let views = Bundle.main.loadNibNamed("ItemsSettingsView", owner: nil, options: nil)
        let itemsSettingsView = views?.first as! ItemsSettingsView
//        self.categoriesSettings = itemsSettingsView
//        itemsSettingsView.controller = self
//        settingsUIView = itemsSettingsView
        itemsSettingsView.controller = itemsController
        itemsSettingsView.settingsController = self
        itemsSettingsView.frame.size = itemsViewController.settingsContainer.frame.size
        itemsViewController.settingsContainer.addSubview(itemsSettingsView)
    }
    
    func instantiateAddView() {
        let views = Bundle.main.loadNibNamed("ItemsAddView", owner: nil, options: nil)
        let itemsAddView = views?.first as! ItemsAddView
        itemsAddView.controller = itemsController
        itemsAddView.nameCategoryTextField.border()
        itemsAddView.nameCategoryTextField.paddingLeft()
        itemsAddView.frame.size = itemsViewController!.settingsContainer.frame.size
        itemsViewController!.settingsContainer.addSubview(itemsAddView)
    }
    
    func instantiateEditView() {
        let views = Bundle.main.loadNibNamed("ItemsEditView", owner: nil, options: nil)
        let itemsEditView = views?.first as! ItemsEditView
        itemsEditView.controller = itemsController
        itemsEditView.editTexrField.border()
        itemsEditView.editTexrField.paddingLeft()
        itemsEditView.frame.size = itemsViewController!.settingsContainer.frame.size
        itemsViewController!.settingsContainer.addSubview(itemsEditView)
    }
    
    func instantiateSortView() {
        let views = Bundle.main.loadNibNamed("ItemsSortView", owner: nil, options: nil)
        let itemsSortView = views?.first as! ItemsSortView
        itemsSortView.controller = itemsController
        itemsSortView.frame.size = itemsViewController!.settingsContainer.frame.size
        itemsViewController!.settingsContainer.addSubview(itemsSortView)
    }
    
    func instantiateSearchView() {
        let views = Bundle.main.loadNibNamed("ItemsSearchView", owner: nil, options: nil)
        let itemsSearchView = views?.first as! ItemsSearchView
        itemsSearchView.controller = itemsController
        itemsSearchView.searchTextField.border()
        itemsSearchView.searchTextField.paddingLeft()
        itemsSearchView.frame.size = itemsViewController!.settingsContainer.frame.size
        itemsViewController!.settingsContainer.addSubview(itemsSearchView)
    }
    
//    func instantiateFilterView() {
//        let views = Bundle.main.loadNibNamed("ItemsFilterView", owner: nil, options: nil)
//        let itemsFilterView = views?.first as! ItemsFilterView
//        itemsFilterView.controller = itemsController
//        itemsFilterView.frame.size = itemsViewController!.settingsContainer.frame.size
//        itemsViewController!.settingsContainer.addSubview(itemsFilterView)
//    }
}
