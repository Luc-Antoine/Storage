//
//  CategoriesController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 30/04/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoriesController: UIController {
    
    weak var navigationController: UINavigationController?
    weak var categoriesViewController: CategoriesViewController?
    weak var categoriesTableViewController: CategoriesTableViewController?
    
    var categoriesSort: ArrayDisplay.Sort = .increasing
    var categories: [Category] = []
    var selectedCategories: [Category] = []
    
    private let dataBase = DataBase()
    private let preferences = Preferences()
    
    // MARK: - Instantiate Functions
    
    func instantiateCategoriesViewController(navigationController: UINavigationController) {
        categoriesViewController = instantiate("CategoriesViewController", storyboard: "Categories", bundle: nil)
        push(navigationController, viewController: categoriesViewController!)
        self.navigationController = navigationController
        categoriesViewController!.controller = self
        navigationBarDesign()
    }
    
    func instantiateCategoriesTableViewController(categoriesViewController: CategoriesViewController, container: UIView) {
        categoriesTableViewController = instantiate("CategoriesTableViewController", storyboard: "Categories", bundle: nil)
        child(categoriesViewController, child: categoriesTableViewController!, container: categoriesViewController.tableViewContainer)
        categoriesTableViewController!.controller = self
        getCategory()
    }
    
    func instantiateItemsViewController(category: Category) {
        let itemsController = ItemsController()
        itemsController.instantiateItemsViewContainer(categoriesViewContainer: categoriesViewController!)
        itemsController.categorySelected = category
    }
    
    // MARK: - Category Table View Settings
    
    func instantiateCategoriesSettingsView() {
        let categoriesSettingsView: CategoriesSettingsView = instantiate("CategoriesSettingsView", owner: nil, options: nil)
        child(categoriesSettingsView, container: categoriesViewController!.settingsContainer)
        categoriesSettingsView.controller = self
    }
    
    // MARK: - Category Table View Editing
    
    func instantiateCategoriesEditView() {
        let categoriesEditView: CategoriesEditView = instantiate("CategoriesEditView", owner: nil, options: nil)
        child(categoriesEditView, container: categoriesViewController!.settingsContainer)
        categoriesEditView.controller = self
        categoriesEditView.viewDidAppear()
    }
    
    func categoriesTableViewEditing() {
        categoriesViewController?.tableViewEditing()
        categoriesTableViewController?.tableViewEditing()
    }
    
    func categoriesTableViewEndEditing() {
        categoriesViewController?.tableViewEndEditing()
        categoriesTableViewController?.tableViewEndEditing()
    }
    
    // MARK: - Category Table View Searching
    
    func instantiateCategoriesSearchView() {
        let categoriesSearchView: CategoriesSearchView = instantiate("CategoriesSearchView", owner: nil, options: nil)
        child(categoriesSearchView, container: categoriesViewController!.settingsContainer)
        categoriesSearchView.controller = self
        categoriesSearchView.viewDidAppear()
    }
    
    // MARK: - Category Table View Sorting
    
    func instantiateCategoriesSortView() {
        let categoriesSortView: CategoriesSortView = instantiate("CategoriesSortView", owner: nil, options: nil)
        child(categoriesSortView, container: categoriesViewController!.settingsContainer)
        categoriesSortView.controller = self
        categoriesSortView.viewDidAppear()
    }
    
    func sortCategories() {
        if categories.count > 1 {
            switch categoriesSort {
            case .increasing:
                categories = categories.sorted(by: { $0.name!.lowercased() < $1.name!.lowercased() })
                break
            case .decreasing:
                categories = categories.sorted(by: { $0.name!.lowercased() > $1.name!.lowercased() })
                break
            case .favoritesFirst:
                categories = categories.sorted(by: { $0.favorites && !$1.favorites })
                break
            case .favoritesLast:
                categories = categories.sorted(by: { !$0.favorites && $1.favorites })
                break
            }
        }
        categoriesTableViewController?.categories = categories
        categoriesTableViewController?.reloadData()
    }
    
    // MARK: - Category Add
    
    func instantiateCategoriesAddView() {
        let categoriesAddView: CategoriesAddView = instantiate("CategoriesAddView", owner: nil, options: nil)
        child(categoriesAddView, container: categoriesViewController!.settingsContainer)
        categoriesAddView.controller = self
        categoriesAddView.viewDidAppear()
    }
    
    // UITextField Functions
    
    func textFieldDidResearching(_ text: String) {
        categoriesTableViewController?.textFieldDidResearching(text)
    }
    
    // MARK: - Remove Container View
    
    func removeSettingsContainer() {
        categoriesViewController?.settingsContainer.subviews.first!.removeFromSuperview()
    }
    
    // MARK: - Categories Functions
    
    func firstTime() {
        if !preferences.existPreferences(data: "id_category") {
            preferences.savePreferences(value: 0, key: "id_category")
            preferences.savePreferences(value: 0, key: "id_item")
            preferences.savePreferences(value: 0, key: "id_annotation")
        }
    }
    
    func getCategory() {
        categories = dataBase.getCategories()
        sortCategories()
    }
    
    func addCategory(newCategoryName: String) {
        guard newCategoryName != "" else { return }
        dataBase.addCategory(categoryName: newCategoryName)
        categories = dataBase.getCategories()
        sortCategories()
    }
    
    func removeCategory(categories: [Category]) {
        do {
            try dataBase.delete(categories)
            getCategory()
            categoriesTableViewEndEditing()
            removeSettingsContainer()
            instantiateCategoriesSettingsView()
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    // MARK: - Design Functions
    
    func navigationBarDesign() {
        let nav = navigationController?.navigationBar
        nav?.isTranslucent = false
        //nav?.barTintColor = UIColor(red: 49/255, green: 140/255, blue: 231/255, alpha: 1)
        //nav?.barTintColor = UIColor(red: 7/255, green: 90/255, blue: 172/255, alpha: 1)
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 7/255, green: 90/255, blue: 172/255, alpha: 1)]
    }
}
