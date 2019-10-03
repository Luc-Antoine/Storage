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
    weak var itemsEditTextFieldDelegate: ItemsEditTextFieldDelegate?
    
    var category: Category?
    var navBarItemFilter: NavBarItemFilter? = .add
    var tableViewStat: TableViewStat?
    var research: Research?
    var lastItemSelected: Item?
    
    @IBOutlet weak var settingsContainer: UIView!
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var addOrDeleteButton: UIBarButtonItem!
    
    private let preferences = Preferences()

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
        let itemsTableViewController: ItemsTableViewController = instantiate("ItemsTableViewController", storyboard: "Items")
        itemsTableViewController.delegate = self
        itemsTableViewController.category = category
        tableViewDelegate = itemsTableViewController
        itemsTableViewController.itemsSort = Sort(rawValue: preferences.itemSort()) ?? .increasing
        itemsTableViewController.research = research
        addChild(itemsTableViewController, container: tableViewContainer)
    }
    
    func newItemsSettingsViewController() {
        let itemsSettingsViewController: ItemsSettingsViewController = instantiate("ItemsSettingsViewController", storyboard: "ItemsSettings")
        itemsSettingsViewController.delegate = self
        itemsSettingsViewController.searchCount = research?.count ?? 0
        navBarItemFilter(.add)
        addChild(itemsSettingsViewController, container: settingsContainer)
    }
    
    func newItemsAddViewController() {
        let itemsAddViewController: ItemsAddViewController = instantiate("ItemsAddViewController", storyboard: "ItemsAdd")
        itemsAddViewController.delegate = self
        navBarItemFilter(nil)
        addChild(itemsAddViewController, container: settingsContainer)
    }
    
    func newItemsEditViewController() {
        let itemsEditViewController: ItemsEditViewController = instantiate("ItemsEditViewController", storyboard: "ItemsEdit")
        itemsEditViewController.delegate = self
        itemsEditTextFieldDelegate = itemsEditViewController
        tableViewDelegate?.tableViewEditing()
        tableViewStat = .editing
        navBarItemFilter(.delete)
        addChild(itemsEditViewController, container: settingsContainer)
    }
    
    func newItemsSortViewController() {
        let itemsSortViewController: ItemsSortViewController = instantiate("ItemsSortViewController", storyboard: "ItemsSort")
        itemsSortViewController.delegate = self
        navBarItemFilter(nil)
        addChild(itemsSortViewController, container: settingsContainer)
    }
    
    func newItemsSearchViewController() {
        let itemsSearchViewController: ItemsSearchViewController = instantiate("ItemsSearchViewController", storyboard: "ItemsSearch")
        itemsSearchViewController.delegate = self
        itemsSearchViewController.research = research
        tableViewDelegate?.kindItem(.researchingItems)
        tableViewDelegate?.textFieldDidBeginResearching()
        tableViewStat = .searching
        navBarItemFilter(nil)
        addChild(itemsSearchViewController, container: settingsContainer)
    }
    
    func newItemsFilterViewController() {
        let itemsFilterViewController: ItemsFilterViewController = instantiate("ItemsFilterViewController", storyboard: "ItemsFilter")
        itemsFilterViewController.delegate = self
        navBarItemFilter(nil)
        tableViewDelegate?.filter()
        addChild(itemsFilterViewController, container: settingsContainer)
    }
    
    func newChildSettings() {
        newItemsSettingsViewController()
        guard tableViewStat != nil else { return }
        switch tableViewStat! {
        case .editing:
            tableViewDelegate?.tableViewEndEditing()
            tableViewStat = nil
            break
        case .searching:
//            tableViewDelegate?.textFieldDidEndEditing()
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
    func editTextField(_ text: String)
    func editTextFieldEndEditing()
    func itemSelected(_ item: Item?)
}

extension ItemsViewController: ItemsTableViewControllerDelegate {
    func newFeaturesViewController(_ item: Item) {
        let featuresViewController: FeaturesViewController = instantiate("FeaturesViewController", storyboard: "Features")
        featuresViewController.category = category
        featuresViewController.item = item
        navigationController?.pushViewController(featuresViewController, animated: true)
    }
    
    func navBarItemFilterOption() -> NavBarItemFilter? {
        return navBarItemFilter
    }
    
    func editTextField(_ text: String) {
        itemsEditTextFieldDelegate?.text(text)
    }
    
    func editTextFieldEndEditing() {
        itemsEditTextFieldDelegate?.editTextFieldEndEditing()
    }
    
    func itemSelected(_ item: Item?) {
        itemsEditTextFieldDelegate?.textFieldBackViewBorder(item)
        lastItemSelected = item
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
    func newChildSettings()
}

extension ItemsViewController: ItemsAddViewControllerDelegate {
    func addItem(_ name: String?) {
        tableViewDelegate?.addItem(name)
    }
}

// MARK: - ItemsEditViewControllerDelegate

protocol ItemsEditViewControllerDelegate: AnyObject {
    func itemsTableViewEditing()
    func itemsTableViewEndEditing()
    func editNameItem(_ name: String) -> Bool
    func textFieldDidResearching(_ text: String)
    func newChildSettings()
    func itemSelected() -> Item?
}

extension ItemsViewController: ItemsEditViewControllerDelegate {
    
    func itemsTableViewEditing() {
        tableViewDelegate?.tableViewEditing()
    }
    
    func itemsTableViewEndEditing() {
        tableViewDelegate?.tableViewEndEditing()
    }
    
    func textFieldDidResearching(_ text: String) {
        tableViewDelegate?.textFieldDidResearching(text)
    }
    
    func editNameItem(_ name: String) -> Bool {
        return tableViewDelegate?.update(name) ?? false
    }
    
    func itemSelected() -> Item? {
        return lastItemSelected
    }
}

// MARK: - ItemsSortViewControllerDelegate

protocol ItemsSortViewControllerDelegate: AnyObject {
    func sortChoice(_ itemsSort: Sort)
    func categoriesSortIndex() -> Sort?
    func newChildSettings()
}

extension ItemsViewController: ItemsSortViewControllerDelegate {
    
    func sortChoice(_ itemsSort: Sort) {
        preferences.itemSort(itemsSort.rawValue)
        tableViewDelegate?.itemsSort(itemsSort)
    }
    
    func categoriesSortIndex() -> Sort? {
        return Sort(rawValue: preferences.itemSort())
    }
}

// MARK: - ItemsSearchViewControllerDelegate

protocol ItemsSearchViewControllerDelegate: AnyObject {
    func textFieldDidResearching(_ text: String)
    func newChildSettings()
//    func endResearching()
    func removeSearch()
    func researching(_ text: String?)
}

extension ItemsViewController: ItemsSearchViewControllerDelegate {
//    func endResearching() {
//        tableViewDelegate?.kindItem(.items)
//    }
    
    func removeSearch() {
        tableViewDelegate?.textFieldDidEndResearching()
        research = nil
    }
    
    func researching(_ text: String?) {
        guard text != nil || text != "" else { return }
        research = Research.init(search: text!, count: tableViewDelegate?.searchCount() ?? 0)
    }
}

// MARK: - ItemsFilterViewControllerDelegate

protocol ItemsFilterViewControllerDelegate: AnyObject {
    func filters()
    func newChildSettings()
    func cancelFilter()
    func tableViewKindItem() -> KindItem?
}

extension ItemsViewController: ItemsFilterViewControllerDelegate {
    func filters() {
        tableViewDelegate?.filters()
    }
    
    func cancelFilter() {
        tableViewDelegate?.resetFilters()
        tableViewDelegate?.kindItem(.items)
        tableViewDelegate?.reloadData()
    }
    
    func tableViewKindItem() -> KindItem? {
        return tableViewDelegate?.tableViewKindItem()
        
    }
}

