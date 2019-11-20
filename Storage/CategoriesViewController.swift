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
    weak var categoryEditDelegate: CategoriesEditDelegate?
    
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
            categoryEditDelegate?.text("")
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
        let categoriesSettingsViewController: CategoriesSettingsViewController = instantiate("CategoriesSettingsViewController", storyboard: "CategoriesSettings")
        categoriesSettingsViewController.delegate = self
        categoriesSettingsViewController.searchCount = research?.count ?? 0
        navBarOption(.add)
        addChild(categoriesSettingsViewController, container: settingsContainer)
    }
    
    func newCategoriesAddViewController() {
        let addViewController: AddViewController = instantiate("AddViewController", storyboard: "AddView")
        var addViewModel = AddViewModel()
        addViewModel.delegate = self
        addViewController.viewModel = addViewModel
        navBarOption(nil)
        addChild(addViewController, container: settingsContainer)
        
//        let categoriesAddViewController: CategoriesAddViewController = instantiate("CategoriesAddViewController", storyboard: "CategoriesAdd")
//        categoriesAddViewController.delegate = self
//        navBarOption(nil)
//        addChild(categoriesAddViewController, container: settingsContainer)
    }
    
    func newCategoriesEditViewController() {
        let categoriesEditViewController: CategoriesEditViewController = instantiate("CategoriesEditViewController", storyboard: "CategoriesEdit")
        categoriesEditViewController.delegate = self
        categoryEditDelegate = categoriesEditViewController
        tableViewDelegate?.tableViewEditing()
        tableViewStat = .editing
        navBarOption(.delete)
        addChild(categoriesEditViewController, container: settingsContainer)
    }
    
    func newCategoriesSortViewController() {
        let sortViewController: SortViewController = instantiate("SortViewController", storyboard: "SortView")
        var sortViewModel = SortViewModel()
        sortViewModel.delegate = self
        sortViewController.viewModel = sortViewModel
        sortViewController.data = "categories"
        navBarOption(nil)
        addChild(sortViewController, container: settingsContainer)
        
//        let categoriesSortViewController: CategoriesSortViewController = instantiate("CategoriesSortViewController", storyboard: "CategoriesSort")
//        categoriesSortViewController.delegate = self
//        navBarOption(nil)
//        addChild(categoriesSortViewController, container: settingsContainer)
    }
    
    func newCategoriesSearchViewController() {
        let categoriesSearchViewController: CategoriesSearchViewController = instantiate("CategoriesSearchViewController", storyboard: "CategoriesSearch")
        categoriesSearchViewController.delegate = self
        categoriesSearchViewController.research = research
        tableViewDelegate?.textFieldDidBeginResearching()
        tableViewStat = .searching
        navBarOption(nil)
        addChild(categoriesSearchViewController, container: settingsContainer)
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
        categoryEditDelegate?.text(text)
    }
    
    func editTextFieldEndEditing() {
        categoryEditDelegate?.editTextFieldEndEditing()
    }
    
    func categorySelected(_ category: Category?) {
        categoryEditDelegate?.textFieldBackViewBorder(category)
        lastCategorySelected = category
    }
}


// MARK: - CategoriesSettingsViewControllerDelegate

protocol CategoriesSettingsViewControllerDelegate: AnyObject {
    func navigationSettings(_ index: Int)
}

extension CategoriesViewController: CategoriesSettingsViewControllerDelegate {
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

// MARK: - CategoriesAddViewControllerDelegate

//protocol CategoriesAddViewControllerDelegate: AnyObject {
//    func addCategory(_ name: String?)
//    func newChildSettings()
//}
//
//extension CategoriesViewController: CategoriesAddViewControllerDelegate {
//    func addCategory(_ name: String?) {
//        tableViewDelegate?.addCategories(name)
//    }
//}

extension CategoriesViewController: AddViewDelegate {
    func add(name: String) {
        tableViewDelegate?.addCategories(name)
    }
}

// MARK: - CategoriesEditViewControllerDelegate

protocol CategoriesEditViewControllerDelegate: AnyObject {
    func categoryTableViewEditing()
    func editNameCategory(_ name: String) -> Bool
    func textFieldDidResearching(_ text: String)
    func newChildSettings()
    func categorySelected() -> Category?
}

extension CategoriesViewController: CategoriesEditViewControllerDelegate {
    
    func categoryTableViewEditing() {
        tableViewDelegate?.tableViewEditing()
    }
    
    func textFieldDidResearching(_ text: String) {
        tableViewDelegate?.textFieldDidResearching(text)
    }
    
    func editNameCategory(_ name: String) -> Bool {
        return tableViewDelegate?.update(name) ?? false
    }
    
    func categorySelected() -> Category? {
        return lastCategorySelected
    }
}

// MARK: - CategoriesSortViewControllerDelegate

//protocol CategoriesSortViewControllerDelegate: AnyObject {
//    func sortChoice(_ categoriesSort: Sort)
//    func categoriesSortIndex() -> Sort?
//    func newChildSettings()
//}
//
//extension CategoriesViewController: CategoriesSortViewControllerDelegate {
//
//    func sortChoice(_ categoriesSort: Sort) {
//        preferences.categorySort(categoriesSort.rawValue)
//        tableViewDelegate?.categoriesSort(categoriesSort)
//    }
//
//    func categoriesSortIndex() -> Sort? {
//        return Sort(rawValue: preferences.categorySort())
//    }
//}

extension CategoriesViewController: SortViewDelegate {
    func newSort(_ sort: Sort) {
        tableViewDelegate?.categoriesSort(sort)
    }
}

// MARK: - CategoriesSearchViewControllerDelegate

protocol CategoriesSearchViewControllerDelegate: AnyObject {
    func textFieldDidResearching(_ text: String)
    func newChildSettings()
    func removeSearch()
    func researching(_ text: String?)
}

extension CategoriesViewController: CategoriesSearchViewControllerDelegate {
    func removeSearch() {
        tableViewDelegate?.textFieldDidEndResearching()
        research = nil
    }
    
    func researching(_ text: String?) {
        guard text != nil || text != "" else { return }
        research = Research.init(search: text!, count: tableViewDelegate?.searchCount() ?? 0)
    }
}
