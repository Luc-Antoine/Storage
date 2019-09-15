//
//  ItemsViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 18/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController {
    
    weak var tableViewDelegate: ItemsViewControllerDelegate?
    
    var category: Category?
    var navBarItemFilter: NavBarItemFilter? = .add
    var tableViewStat: TableViewStat?
    
    @IBOutlet weak var settingsContainer: UIView!
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var addOrDeleteButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBack()
        newItemsTableViewController()
        newItemsSettingsViewController()
        title = category!.name
    }
    
    // MARK: - IBActions
    
    @IBAction func addOrDeleteAction() {
        guard navBarItemFilter != nil else { return }
        switch navBarItemFilter! {
        case .add:
            newItemsAddViewController()
            break
        case .delete:
            tableViewDelegate?.removeItems()
            break
        case .filter:
            tableViewDelegate?.kindItem(.nameFeatures)
            navBarItemFilter(nil)
            tableViewDelegate?.reloadData()
            break
        }
    }
    
    // MARK: - Navigation
    
    func newItemsTableViewController() {
        let itemsTableViewController: ItemsTableViewController = instantiate("ItemsTableViewController", container: tableViewContainer, storyboard: "Items")
        itemsTableViewController.delegate = self
        itemsTableViewController.category = category
        tableViewDelegate = itemsTableViewController
    }
    
    func newItemsSettingsViewController() {
        let itemsSettingsViewController: ItemsSettingsViewController = instantiate("ItemsSettingsViewController", container: settingsContainer, storyboard: "ItemsSettingsView")
        itemsSettingsViewController.delegate = self
        navBarItemFilter(.add)
    }
    
    func newItemsAddViewController() {
        let itemsAddViewController: ItemsAddViewController = instantiate("ItemsAddViewController", container: settingsContainer, storyboard: "ItemsAddView")
        itemsAddViewController.delegate = self
        navBarItemFilter(nil)
    }
    
    func newItemsEditViewController() {
        let itemsEditViewController: ItemsEditViewController = instantiate("ItemsEditViewController", container: settingsContainer, storyboard: "ItemsEditView")
        itemsEditViewController.delegate = self
        tableViewDelegate?.tableViewEditing()
        tableViewStat = .editing
        navBarItemFilter(.delete)
    }
    
    func newItemsSortViewController() {
        let itemsSortViewController: ItemsSortViewController = instantiate("ItemsSortViewController", container: settingsContainer, storyboard: "ItemsSortView")
        itemsSortViewController.delegate = self
        navBarItemFilter(nil)
    }
    
    func newItemsSearchViewController() {
        let itemsSearchViewController: ItemsSearchViewController = instantiate("ItemsSearchViewController", container: settingsContainer, storyboard: "ItemsSearchView")
        itemsSearchViewController.delegate = self
        tableViewDelegate?.kindItem(.researchingItems)
        tableViewDelegate?.textFieldDidBeginEditing()
        tableViewStat = .searching
        navBarItemFilter(nil)
    }
    
    func newItemsFilterViewController() {
        let itemsFilterViewController: ItemsFilterViewController = instantiate("ItemsFilterViewController", container: settingsContainer, storyboard: "ItemsFilterView")
        itemsFilterViewController.delegate = self
        navBarItemFilter(nil)
        tableViewDelegate?.filter()
    }
    
    func removeChildSettings() {
        newItemsSettingsViewController()
        guard tableViewStat != nil else { return }
        switch tableViewStat! {
        case .editing:
            tableViewDelegate?.tableViewEndEditing()
            tableViewStat = nil
            break
        case .searching:
            tableViewDelegate?.textFieldDidEndEditing()
            break
        }
    }
    
    func navBarItemFilter(_ option: NavBarItemFilter?) {
        navBarItemFilter = option
        if option == nil {
            addOrDeleteButton.image = nil
            addOrDeleteButton.isEnabled = false
        } else {
            switch option! {
            case .add:
                addOrDeleteButton.isEnabled = true
                addOrDeleteButton.image = UIImage(named: "Add")
                break
            case .delete:
                addOrDeleteButton.isEnabled = true
                addOrDeleteButton.image = UIImage(named: "Basket")
                break
            case .filter:
                addOrDeleteButton.isEnabled = true
                addOrDeleteButton.image = UIImage(named: "Add")
                break
            }
        }
    }
}

// MARK: - ItemsTableViewControllerDelegate

protocol ItemsTableViewControllerDelegate: AnyObject {
    func newFeaturesViewController(_ item: Item)
    func navBarItemFilterOption() -> NavBarItemFilter?
}

extension ItemsViewController: ItemsTableViewControllerDelegate {
    func newFeaturesViewController(_ item: Item) {
        let featuresViewController: FeaturesViewController = instantiate("FeaturesViewController", navigationController: navigationController!, storyboard: "Features")
        featuresViewController.category = category
        featuresViewController.item = item
    }
    
    func navBarItemFilterOption() -> NavBarItemFilter? {
        return navBarItemFilter
    }
}

// MARK: - ItemsSettingsViewControllerDelegate

protocol ItemsSettingsViewControllerDelegate: AnyObject {
    func navigationSettings(_ index: Int)
    func filterTitle() -> String
}

extension ItemsViewController: ItemsSettingsViewControllerDelegate {
    func navigationSettings(_ index: Int) {
        switch index {
        case 0:
            newItemsEditViewController()
            break
        case 1:
            newItemsSortViewController()
            break
        case 2:
            newItemsSearchViewController()
            break
        case 3:
            newItemsFilterViewController()
            break
        default:
            break
        }
    }
    
    func filterTitle() -> String {
        let filters: Int = tableViewDelegate?.featuresFilteredByItemCount() ?? 0
        guard filters > 0 else { return NSLocalizedString("Filter", comment: "") }
        return NSLocalizedString("Filter ", comment: "") + "(\(filters))"
    }
}

// MARK: - ItemsAddViewControllerDelegate

protocol ItemsAddViewControllerDelegate: AnyObject {
    func addItem(_ name: String?)
    func removeChildSettings()
}

extension ItemsViewController: ItemsAddViewControllerDelegate {
    func addItem(_ name: String?) {
        tableViewDelegate?.addItem(name)
    }
}

// MARK: - ItemsEditViewControllerDelegate

protocol ItemsEditViewControllerDelegate: AnyObject {
    func textFieldDidResearching(_ text: String)
    func removeChildSettings()
}

extension ItemsViewController: ItemsEditViewControllerDelegate {
    func textFieldDidResearching(_ text: String) {
        tableViewDelegate?.textFieldDidResearching(text)
    }
}

// MARK: - ItemsSortViewControllerDelegate

protocol ItemsSortViewControllerDelegate: AnyObject {
    func sortChoice(_ itemsSort: Sort)
    func categoriesSortIndex() -> Sort?
    func removeChildSettings()
}

extension ItemsViewController: ItemsSortViewControllerDelegate {
    
    func sortChoice(_ itemsSort: Sort) {
        tableViewDelegate?.itemsSort(itemsSort)
    }
    
    func categoriesSortIndex() -> Sort? {
        return tableViewDelegate?.tableViewItemsSort()
    }
}

// MARK: - ItemsSearchViewControllerDelegate

protocol ItemsSearchViewControllerDelegate: AnyObject {
    func textFieldDidResearching(_ text: String)
    func removeChildSettings()
    func endResearching()
}

extension ItemsViewController: ItemsSearchViewControllerDelegate {
    func endResearching() {
        tableViewDelegate?.kindItem(.items)
    }
}

// MARK: - ItemsFilterViewControllerDelegate

protocol ItemsFilterViewControllerDelegate: AnyObject {
    func filters()
    func removeChildSettings()
    func cancelFilter()
    func tableViewKindItem() -> KindItem?
}

extension ItemsViewController: ItemsFilterViewControllerDelegate {
    func filters() {
        tableViewDelegate?.filters()
    }
    
    func cancelFilter() {
        tableViewDelegate?.kindItem(.items)
        tableViewDelegate?.reloadData()
    }
    
    func tableViewKindItem() -> KindItem? {
        return tableViewDelegate?.tableViewKindItem()
        
    }
}

