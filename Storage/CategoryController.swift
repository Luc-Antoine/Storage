//
//  CategoryController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 30/04/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoryController {
    
    weak var navigationController: UINavigationController?
    weak var categoryViewController: CategoryViewController?
    weak var categoryTableViewController: CategoryTableViewController?
    weak var categorySettings: CategorySettings?
    
    private let dataBase = DataBase()
    private let preferences = Preferences()
    
    // MARK: - Instantiate Functions
    
    func instantiateCategoryViewController(navigationController: UINavigationController) {
        self.navigationController = navigationController
        let storyboard = UIStoryboard(name: "Category", bundle: nil)
        let categoryViewController = (storyboard.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController)
        categoryViewController.controller = self
        self.categoryViewController = categoryViewController
        navigationController.pushViewController(categoryViewController, animated: true)
    }
    
    func instantiateCategoryTableViewController(categoryViewController: CategoryViewController, container: UIView) {
        let storyboard = UIStoryboard(name: "Category", bundle: nil)
        categoryTableViewController = (storyboard.instantiateViewController(withIdentifier: "CategoryTableViewController") as! CategoryTableViewController)
        categoryTableViewController!.controller = self
        categoryViewController.addChild(categoryTableViewController!)
        categoryTableViewController!.view.frame.size = categoryViewController.tableViewContainer.frame.size
        categoryViewController.tableViewContainer.addSubview(categoryTableViewController!.view)
        getCategory()
    }
    
    func instantiateItemsViewController(category: Category) {
        let storyboard = UIStoryboard(name: "Collector", bundle: nil)
        let itemsViewController = storyboard.instantiateViewController(withIdentifier: "ItemsViewController") as! ListItemViewController
        itemsViewController.categorySelected = category
        navigationController!.pushViewController(itemsViewController, animated: true)
    }
    
    // MARK: - Category Table View Settings
    
    func instantiateCategorySettings() {
        let views = Bundle.main.loadNibNamed("CategorySettings", owner: nil, options: nil)
        let categorySettings = views?.first as! CategorySettings
        self.categorySettings = categorySettings
        categorySettings.controller = self
        categoryViewController?.settingsContainer.addSubview(categorySettings)
    }
    
    // MARK: - Category Table View Editing
    
    func instantiateCategoryEdit() {
        let views = Bundle.main.loadNibNamed("CategoryEdit", owner: nil, options: nil)
        let categoryEdit = views?.first as! CategoryEdit
        categoryEdit.controller = self
//        categoryEdit.frame.size = (categoryViewController?.settingsContainer.frame.size)!
        categoryViewController?.settingsContainer.addSubview(categoryEdit)
    }
    
    func categoryTableViewEditing() {
//        addButton.image = #imageLiteral(resourceName: "Basket")
//        tableView.allowsMultipleSelectionDuringEditing = true
//            tableView.setEditing(true, animated: true)
//            tableView.layoutMargins = UIEdgeInsets.init(top: 0, left: 40, bottom: 0, right: 0)
//            modify = true
        
        categoryTableViewController?.tableView.allowsMultipleSelectionDuringEditing = true
        
    }
    
    // MARK: - Category Table View Filtering
    
    func instantiateCategoryFilter() {
        let views = Bundle.main.loadNibNamed("CategoryFilter", owner: nil, options: nil)
        let categoryFilter = views?.first as! CategoryFilter
        categoryFilter.controller = self
        categoryViewController?.settingsContainer.addSubview(categoryFilter)
    }
    
    func categoryTableViewFiltering() {
        
    }
    
    // MARK: - Category Table View Searching
    
    func instantiateCategorySearch() {
        let views = Bundle.main.loadNibNamed("CategorySearch", owner: nil, options: nil)
        let categorySearch = views?.first as! CategorySearch
        categorySearch.controller = self
        categoryViewController?.settingsContainer.addSubview(categorySearch)
    }
    
    func categoryTableViewSearching() {
//            searchBar.becomeFirstResponder()
    }
    
    // MARK: - Category Table View Sorting
    
    func instantiateCategorySort() {
        let views = Bundle.main.loadNibNamed("CategorySort", owner: nil, options: nil)
        let categorySort = views?.first as! CategorySort
        categorySort.controller = self
        categoryViewController?.settingsContainer.addSubview(categorySort)
    }
    
    func categoryTableViewSorting() {
        
    }
    
    func removeSettingsContainer() {
        categoryViewController?.settingsContainer.subviews.first!.removeFromSuperview()
    }
    
    // MARK: - Categories Functions
    
    func updateCategories(category: [Category]) {
        categoryTableViewController!.category = category
        categoryTableViewController?.reloadData()
    }
    
    func firstTime() {
        if !preferences.existPreferences(data: "id_category") {
            preferences.savePreferences(value: 0, key: "id_category")
            preferences.savePreferences(value: 0, key: "id_item")
            preferences.savePreferences(value: 0, key: "id_annotation")
        }
    }
    
    func getCategory() {
        dataBase.getCategory(completion: { results in
            self.sortCategories(category: results, categorySort: .increasing)
        })
    }
    
    func sortCategories(category: [Category], categorySort: ArrayDisplay.Sort) {
        var results: [Category] = category
        if category.count > 1 {
            switch categorySort {
            case .increasing:
                results = category.sorted(by: { $0.name!.lowercased() < $1.name!.lowercased() })
                break
            case .decreasing:
                results = category.sorted(by: { $0.name!.lowercased() > $1.name!.lowercased() })
                break
            case .favoritesFirst:
                results = category.sorted(by: { $0.favorites && !$1.favorites })
                break
            case .favoritesLast:
                results = category.sorted(by: { !$0.favorites && $1.favorites })
                break
            }
        }
        updateCategories(category: results)
    }
}
