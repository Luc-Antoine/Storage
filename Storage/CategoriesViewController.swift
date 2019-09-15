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
    
    var navBarItem: NavBarItem? = .add
    var tableViewStat: TableViewStat?
    
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var settingsContainer: UIView!
    @IBOutlet weak var addOrDeleteButton: UIBarButtonItem!
    
    private let dataBase = DataBase()
    private let preferences = Preferences()
    private let styleCSS = StyleCSS()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarDesign()
        navigationBack()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
            break
        }
    }
    
    // MARK: - Navigation
    
    func newCategoriesTableViewController() {
        let categoriesTableViewController: CategoriesTableViewController = instantiate( "CategoriesTableViewController", container: tableViewContainer, storyboard: "Categories")
        categoriesTableViewController.delegate = self
        tableViewDelegate = categoriesTableViewController
    }
    
    func newCategoriesSettingsViewController() {
        let categoriesSettingsViewController: CategoriesSettingsViewController = instantiate("CategoriesSettingsViewController", container: settingsContainer, storyboard: "CategoriesSettingsView")
        categoriesSettingsViewController.delegate = self
        navBarOption(.add)
    }
    
    func newCategoriesAddViewController() {
        let categoriesAddViewController: CategoriesAddViewController = instantiate("CategoriesAddViewController", container: settingsContainer, storyboard: "CategoriesAddView")
        categoriesAddViewController.delegate = self
        navBarOption(nil)
    }
    
    func newCategoriesEditViewController() {
        let categoriesEditViewController: CategoriesEditViewController = instantiate("CategoriesEditViewController", container: settingsContainer, storyboard: "CategoriesEditView")
        categoriesEditViewController.delegate = self
        tableViewDelegate?.tableViewEditing()
        tableViewStat = .editing
        navBarOption(.delete)
    }
    
    func newCategoriesSortViewController() {
        let categoriesSortViewController: CategoriesSortViewController = instantiate("CategoriesSortViewController", container: settingsContainer, storyboard: "CategoriesSortView")
        categoriesSortViewController.delegate = self
        navBarOption(nil)
    }
    
    func newCategoriesSearchViewController() {
        let categoriesSearchViewController: CategoriesSearchViewController = instantiate("CategoriesSearchViewController", container: settingsContainer, storyboard: "CategoriesSearchView")
        categoriesSearchViewController.delegate = self
        tableViewDelegate?.textFieldDidBeginEditing()
        tableViewStat = .searching
        navBarOption(nil)
    }
    
    func removeChildSettings() {
        newCategoriesSettingsViewController()
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
    
    // MARK: - DataBase Functions
    
    func initDataBase() {
        guard !preferences.dataBaseCreated() else { return }
        dataBase.createCategoryTable()
        dataBase.createItemTable()
        dataBase.createAnnotationTable()
        dataBase.createNameFeaturesTable()
        dataBase.createFeaturesTable()
        dataBase.createItemFeatureTable()
        preferences.lastFeatureId(-1)
        preferences.dataBaseCreated(true)
        
        let demonstration = Demonstration()
        demonstration.run()
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
}

extension CategoriesViewController: CategoriesTableViewControllerDelegate {
    func newItemsViewController(_ category: Category) {
        let itemsViewController: ItemsViewController = instantiate("ItemsViewController", navigationController: navigationController!, storyboard: "Items")
        itemsViewController.category = category
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

protocol CategoriesAddViewControllerDelegate: AnyObject {
    func addCategory(_ name: String?)
    func removeChildSettings()
}

extension CategoriesViewController: CategoriesAddViewControllerDelegate {
    func addCategory(_ name: String?) {
        tableViewDelegate?.addCategories(name)
    }
}

// MARK: - CategoriesEditViewControllerDelegate

protocol CategoriesEditViewControllerDelegate: AnyObject {
    func textFieldDidResearching(_ text: String)
    func removeChildSettings()
}

extension CategoriesViewController: CategoriesEditViewControllerDelegate {
    func textFieldDidResearching(_ text: String) {
        tableViewDelegate?.textFieldDidResearching(text)
    }
}

// MARK: - CategoriesSortViewControllerDelegate

protocol CategoriesSortViewControllerDelegate: AnyObject {
    func sortChoice(_ categoriesSort: Sort)
    func categoriesSortIndex() -> Sort?
    func removeChildSettings()
}

extension CategoriesViewController: CategoriesSortViewControllerDelegate {
    
    func sortChoice(_ categoriesSort: Sort) {
        tableViewDelegate?.categoriesSort(categoriesSort)
    }
    
    func categoriesSortIndex() -> Sort? {
        return tableViewDelegate?.tableViewCategoriesSort()
    }
}

// MARK: - CategoriesSearchViewControllerDelegate

protocol CategoriesSearchViewControllerDelegate: AnyObject {
    func textFieldDidResearching(_ text: String)
    func removeChildSettings()
}

extension CategoriesViewController: CategoriesSearchViewControllerDelegate {
    // No additionnal Function are required for this delegate.
}
