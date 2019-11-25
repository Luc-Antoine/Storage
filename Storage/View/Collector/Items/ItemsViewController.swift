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
    weak var editToViewControllersDelegate: EditToViewControllersDelegate?
    
    var category: Category?
    var navBarItemFilter: NavBarItemFilter? = .add
    var tableViewStat: TableViewStat?
    var lastItemSelected: Item?
    
    @IBOutlet weak var settingsContainer: UIView!
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var addOrDeleteButton: UIBarButtonItem!
    
    private let preferences = Preferences()

    override func viewDidLoad() {
        super.viewDidLoad()

        title(category!.name)
        navigationBack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        newItemsTableViewController()
        newItemsSettingsViewController()
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
            editToViewControllersDelegate?.text("")
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
        addChild(itemsTableViewController, container: tableViewContainer)
    }
    
    func newItemsSettingsViewController() {
        let settingsViewController: SettingsViewController = instantiate("SettingsViewController", storyboard: "SettingsView")
        var settingsViewModel = SettingsViewModel()
        settingsViewModel.delegate = self
        settingsViewController.viewModel = settingsViewModel
        settingsViewController.data = "items"
        settingsViewController.filterCount = tableViewDelegate?.featuresFilteredByItemCount() ?? 0
        navBarItemFilter(.add)
        addChild(settingsViewController, container: settingsContainer)
    }
    
    func newItemsAddViewController() {
        let addViewController: AddViewController = instantiate("AddViewController", storyboard: "AddView")
        var addViewModel = AddViewModel()
        addViewModel.delegate = self
        addViewController.viewModel = addViewModel
        navBarItemFilter(nil)
        addChild(addViewController, container: settingsContainer)
    }
    
    func newItemsEditViewController() {
        let editViewController: EditViewController = instantiate("EditViewController", storyboard: "EditView")
        var editViewModel = EditViewModel()
        editViewModel.delegate = self
        editViewController.viewModel = editViewModel
        editToViewControllersDelegate = editViewController
        tableViewDelegate?.tableViewEditing()
        tableViewStat = .editing
        navBarItemFilter(.delete)
        addChild(editViewController, container: settingsContainer)
    }
    
    func newItemsSortViewController() {
        let sortViewController: SortViewController = instantiate("SortViewController", storyboard: "SortView")
        var sortViewModel = SortViewModel()
        sortViewModel.delegate = self
        sortViewController.viewModel = sortViewModel
        sortViewController.data = "items"
        navBarItemFilter(nil)
        addChild(sortViewController, container: settingsContainer)
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
        if tableViewStat == .editing {
            tableViewDelegate?.tableViewEndEditing()
            tableViewStat = nil
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
        editToViewControllersDelegate?.text(text)
    }
    
    func editTextFieldEndEditing() {
        editToViewControllersDelegate?.editTextFieldEndEditing()
    }
    
    func itemSelected(_ item: Item?) {
        editToViewControllersDelegate?.textFieldBackViewBorder(item != nil)
        lastItemSelected = item
    }
}

// MARK: - SettingsViewDelegate

extension ItemsViewController: SettingsViewDelegate {
    func navigationSettings(_ index: Int) {
        switch index {
        case 0:
            newItemsEditViewController()
            break
        case 1:
            newItemsSortViewController()
            break
        case 2:
            newItemsFilterViewController()
            break
        default:
            break
        }
    }
    
    func filterTitle() -> String {
        let filters: Int = tableViewDelegate?.featuresFilteredByItemCount() ?? 0
        guard filters > 0 else { return NSLocalizedString("Filter", comment: "") }
        return NSLocalizedString("Filter", comment: "") + " (\(filters))"
    }
}

// MARK: - AddViewDelegate

extension ItemsViewController: AddViewDelegate {
    func add(_ name: String) {
        tableViewDelegate?.addItem(name)
    }
}

// MARK: - EditViewDelegate

extension ItemsViewController: EditViewDelegate {
    func objectSelected() -> Bool {
        return lastItemSelected != nil
    }
    
    func tableViewEditing() {
        tableViewDelegate?.tableViewEditing()
    }
    
    func tableViewEndEditing() {
        tableViewDelegate?.tableViewEndEditing()
    }
    
    func editNameObject(_ name: String) -> Bool {
        return tableViewDelegate?.update(name) ?? false
    }
}

// MARK: - SortViewDelegate

extension ItemsViewController: SortViewDelegate {
    func newSort(_ sort: Sort) {
        preferences.itemSort(sort.rawValue)
        tableViewDelegate?.itemsSort(sort)
    }
    
    func categoriesSortIndex() -> Sort? {
        return Sort(rawValue: preferences.itemSort())
    }
}

// MARK: - ItemsFilterViewControllerDelegate

protocol ItemsFilterViewControllerDelegate: AnyObject {
    func filters()
    func newChildSettings()
    func cancelFilter()
    func resetFilters()
    func tableViewKindItem() -> KindItem?
}

extension ItemsViewController: ItemsFilterViewControllerDelegate {
    func filters() {
        tableViewDelegate?.filters()
    }
    
    func cancelFilter() {
        tableViewDelegate?.kindItem(.filteredItems)
        tableViewDelegate?.reloadData()
    }
    
    func resetFilters() {
        tableViewDelegate?.kindItem(.items)
        tableViewDelegate?.resetFilters()
        tableViewDelegate?.reloadData()
    }
    
    func tableViewKindItem() -> KindItem? {
        return tableViewDelegate?.tableViewKindItem()
    }
}

