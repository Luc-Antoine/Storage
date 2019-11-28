//
//  CategoriesViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 01/05/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

enum TableViewStat {
    case editing, searching
}

enum CategoriesSegmentedIndex: Int {
    case edit = 0, sort, search
}

class CategoriesViewController: UIViewController {
    
    weak var tableViewDelegate: CategoriesViewControllerDelegate?
    weak var editToViewControllersDelegate: EditToViewControllersDelegate?
    
    var navBarItem: NavBarItem? = .add
    var tableViewStat: TableViewStat?
    var research: Research?
    var lastCategorySelected: Category?
    
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var settingsContainer: UIView!
    @IBOutlet weak var addOrDeleteButton: UIBarButtonItem!
    
    private let createDataBase = CreateDataBase()
    private let preferences = Preferences()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDataBase()
        navigationBarDesign()
        navigationBack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        newCategoriesSettingsViewController()
        newCategoriesTableViewController()
    }
    
    // MARK: - IBActions
    
    @IBAction func addOrDeleteAction() {
        guard navBarItem != nil else { return }
        switch navBarItem! {
        case .add:
            newCategoriesAddViewController()
            break
        case .delete:
            tableViewDelegate?.removeCategories()
            editToViewControllersDelegate?.text("")
            break
        }
    }
    
    // MARK: - Navigation
    
    func newCategoriesTableViewController() {
        let categoriesTableViewController: CategoriesTableViewController = instantiate( "CategoriesTableViewController", storyboard: "Categories")
        categoriesTableViewController.delegate = self
        tableViewDelegate = categoriesTableViewController
        categoriesTableViewController.categoriesSort = Sort(rawValue: preferences.categorySort()) ?? .increasing
        categoriesTableViewController.research = research
        addChild(categoriesTableViewController, container: tableViewContainer)
    }
    
    func newCategoriesSettingsViewController() {
        let settingsViewController: SettingsViewController = instantiate("SettingsViewController", storyboard: "SettingsView")
        var settingsViewModel = SettingsViewModel()
        settingsViewModel.delegate = self
        settingsViewController.viewModel = settingsViewModel
        settingsViewController.searchCount = research?.count ?? 0
        navBarOption(.add)
        addChild(settingsViewController, container: settingsContainer)
    }
    
    func newCategoriesAddViewController() {
        let addViewController: AddViewController = instantiate("AddViewController", storyboard: "AddView")
        var addViewModel = AddViewModel()
        addViewModel.delegate = self
        addViewController.viewModel = addViewModel
        navBarOption(nil)
        addChild(addViewController, container: settingsContainer)
    }
    
    func newCategoriesEditViewController() {
        let editViewController: EditViewController = instantiate("EditViewController", storyboard: "EditView")
        var editViewModel = EditViewModel()
        editViewModel.delegate = self
        
        editViewController.viewModel = editViewModel
        editToViewControllersDelegate = editViewController
        tableViewDelegate?.tableViewEditing()
        tableViewStat = .editing
        navBarOption(.delete)
        addChild(editViewController, container: settingsContainer)
    }
    
    func newCategoriesSortViewController() {
        let sortViewController: SortViewController = instantiate("SortViewController", storyboard: "SortView")
        var sortViewModel = SortViewModel()
        sortViewModel.delegate = self
        sortViewController.viewModel = sortViewModel
        sortViewController.data = "categories"
        navBarOption(nil)
        addChild(sortViewController, container: settingsContainer)
    }
    
    func newCategoriesSearchViewController() {
        let searchViewController: SearchViewController = instantiate("SearchViewController", storyboard: "SearchView")
        var searchViewModel = SearchViewModel()
        searchViewModel.delegate = self
        searchViewController.viewModel = searchViewModel
        searchViewController.research = research
        tableViewDelegate?.textFieldDidBeginResearching()
        tableViewStat = .searching
        navBarOption(nil)
        addChild(searchViewController, container: settingsContainer)
    }
    
    func newChildSettings() {
        newCategoriesSettingsViewController()
        guard tableViewStat == .editing else { return }
        tableViewDelegate?.tableViewEndEditing()
        tableViewStat = nil
    }
    
    // MARK: - DataBase Functions
    
    func initDataBase() {
        guard !preferences.dataBaseCreated() else { return }
        createDataBase.execute()
        createDataBase.preferencesDefault()
        createDataBase.demo()
        preferences.lastFeatureId(-1)
        preferences.dataBaseCreated(true)
    }
    
    // MARK: - Navigation Controller Function
    
    func navBarOption(_ option: NavBarItem?) {
        navBarItem = option
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
            }
        }
    }
}

// MARK: - CategoriesTableViewControllerDelegate

protocol CategoriesTableViewControllerDelegate: AnyObject {
    func newItemsViewController(_ category: Category)
    func editTextField(_ text: String)
    func editTextFieldEndEditing()
    func categorySelected(_ category: Category?)
}

extension CategoriesViewController: CategoriesTableViewControllerDelegate {
    func newItemsViewController(_ category: Category) {
        let itemsViewController: ItemsViewController = instantiate("ItemsViewController", storyboard: "Items")
        itemsViewController.category = category
        navigationController?.pushViewController(itemsViewController, animated: true)
    }
    
    func editTextField(_ text: String) {
        editToViewControllersDelegate?.text(text)
    }
    
    func editTextFieldEndEditing() {
        editToViewControllersDelegate?.editTextFieldEndEditing()
    }
    
    func categorySelected(_ category: Category?) {
        lastCategorySelected = category
        editToViewControllersDelegate?.textFieldBackViewBorder(category != nil)
    }
}


// MARK: - SettingsViewDelegate

extension CategoriesViewController: SettingsViewDelegate {
    func navigationSettings(_ index: Int) {
        switch index {
        case 0:
            newCategoriesEditViewController()
            break
        case 1:
            newCategoriesSortViewController()
            break
        case 2:
            newCategoriesSearchViewController()
            break
        default:
            break
        }
    }
}

// MARK: - AddViewDelegate

extension CategoriesViewController: AddViewDelegate {
    func add(_ name: String) {
        tableViewDelegate?.addCategories(name)
    }
}

// MARK: - EditViewDelegate

extension CategoriesViewController: EditViewDelegate {
    func objectSelected() -> Bool {
        return lastCategorySelected != nil
    }
    
    func tableViewEditing() {
        tableViewDelegate?.tableViewEditing()
    }
    
    func textFieldDidResearching(_ text: String) {
        tableViewDelegate?.textFieldDidResearching(text)
    }
    
    func editNameObject(_ name: String) -> Bool {
        return tableViewDelegate?.update(name) ?? false
    }
}

// MARK: - SortViewDelegate

extension CategoriesViewController: SortViewDelegate {
    func newSort(_ sort: Sort) {
        tableViewDelegate?.categoriesSort(sort)
    }
}

// MARK: - SearchViewDelegate

extension CategoriesViewController: SearchViewDelegate {
    func removeSearch() {
        tableViewDelegate?.textFieldDidEndResearching()
        research = nil
    }
    
    func researching(_ text: String?) {
        guard text != nil || text != "" else { return }
        research = Research.init(search: text!, count: tableViewDelegate?.searchCount() ?? 0)
    }
}
