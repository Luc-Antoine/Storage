//
//  ItemsInstantiateViews.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 09/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

extension ItemsController {
    
    // MARK: - Instantiate Functions
    
    func instantiateItemsViewContainer(categoriesViewContainer: CategoriesViewController) {
        itemsViewController = instantiate("ItemsViewController", storyboard: "Items", bundle: nil)
        push(categoriesViewContainer.navigationController!, viewController: itemsViewController!)
        itemsViewController!.controller = self
    }
    
    func instantiateItemsTableViewController() {
        select()
        itemsTableViewContoller = instantiate("ItemsTableViewController", storyboard: "Items", bundle: nil)
        child(itemsViewController!, child: itemsTableViewContoller!, container: itemsViewController!.tableViewContainer)
        itemsTableViewContoller!.controller = self
    }
    
    func instantiateFeaturesController(_ item: Item) {
        let featuresController = FeaturesController()
        featuresController.item = item
        featuresController.category = category
        featuresController.instantiateFeaturesViewController(itemsViewController!.navigationController!)
    }
    
    func removeSettingsContainer() {
        itemsViewController?.settingsContainer.subviews.first?.removeFromSuperview()
    }
    
    // MARK: - Item Settings View
    
    func instantiateItemsSettingsView() {
        itemsSettingsView = instantiate("ItemsSettingsView", owner: nil, options: nil)
        child(itemsSettingsView!, container: itemsViewController!.settingsContainer)
        itemsSettingsView!.controller = self
        itemsSettingsView!.viewDidAppear()
        itemsViewController!.navBarItemFilter(.add)
    }
    
    // MARK: - Item Add View
    
    func instantiateAddView() {
        let itemsAddView: ItemsAddView = instantiate("ItemsAddView", owner: nil, options: nil)
        child(itemsAddView, container: itemsViewController!.settingsContainer)
        itemsAddView.controller = self
        itemsAddView.viewDidAppear()
    }
    
    // MARK: - Item Edit View
    
    func instantiateEditView() {
        let itemsEditView: ItemsEditView = instantiate("ItemsEditView", owner: nil, options: nil)
        child(itemsEditView, container: itemsViewController!.settingsContainer)
        itemsEditView.controller = self
        itemsEditView.viewDidAppear()
        kindItem = .researchingItems
        itemsViewController!.navBarItemFilter(.delete)
    }
    
    // MARK: - Item Sort View
    
    func instantiateSortView() {
        let itemsSortView: ItemsSortView = instantiate("ItemsSortView", owner: nil, options: nil)
        child(itemsSortView, container: itemsViewController!.settingsContainer)
        itemsSortView.controller = self
        itemsSortView.viewDidAppear()
        itemsViewController!.navBarItemFilter(nil)
    }
    
    // MARK: - Item Search View
    
    func instantiateSearchView() {
        let itemsSearchView: ItemsSearchView = instantiate("ItemsSearchView", owner: nil, options: nil)
        child(itemsSearchView, container: itemsViewController!.settingsContainer)
        itemsSearchView.controller = self
        itemsSearchView.searchTextField.delegate = itemsTableViewContoller
        itemsSearchView.viewDidAppear()
        kindItem = .researchingItems
        itemsTableViewContoller!.tableView.reloadData()
        itemsViewController!.navBarItemFilter(nil)
    }
    
    // MARK: - Item Filter View
    
    func instantiateFilterView() {
        let itemFilterView: ItemsFilterView = instantiate("ItemsFilterView", owner: nil, options: nil)
        child(itemFilterView, container: itemsViewController!.settingsContainer)
        itemFilterView.controller = self
        itemFilterView.viewDidAppear()
        if featuresFilteredByName.count > 0 {
            kindItem = .filtersEditing
            itemsViewController!.navBarItemFilter(.filter)
        } else {
            kindItem = .nameFeatures
            itemsViewController!.navBarItemFilter(nil)
        }
        itemsTableViewContoller!.tableView.reloadData()
    }
}
