//
//  CategoriesController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 30/04/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoriesController {
    
    weak var navigationController: UINavigationController?
    weak var categoriesViewController: CategoriesViewController?
    weak var categoriesTableViewController: CategoriesTableViewController?
    weak var categoriesSettings: CategoriesSettingsView?
    
    var settingsUIView: UIView?
    
    var categoriesSort: ArrayDisplay.Sort = .increasing
    var categories: [Category] = []
    var selectedCategories: [Category] = []
    
    private let dataBase = DataBase()
    private let preferences = Preferences()
    
    // MARK: - Instantiate Functions
    
    func instantiateCategoriesViewController(navigationController: UINavigationController) {
        self.navigationController = navigationController
        let storyboard = UIStoryboard(name: "Categories", bundle: nil)
        let categoriesViewController = (storyboard.instantiateViewController(withIdentifier: "CategoriesViewController") as! CategoriesViewController)
        categoriesViewController.controller = self
        self.categoriesViewController = categoriesViewController
        navigationBarDesign()
        navigationController.pushViewController(categoriesViewController, animated: true)
    }
    
    func instantiateCategoriesTableViewController(categoriesViewController: CategoriesViewController, container: UIView) {
        let storyboard = UIStoryboard(name: "Categories", bundle: nil)
        categoriesTableViewController = (storyboard.instantiateViewController(withIdentifier: "CategoriesTableViewController") as! CategoriesTableViewController)
        categoriesTableViewController!.controller = self
        categoriesViewController.addChild(categoriesTableViewController!)
        categoriesTableViewController!.view.frame.size = categoriesViewController.tableViewContainer.frame.size
        categoriesViewController.tableViewContainer.addSubview(categoriesTableViewController!.view)
        getCategory()
    }
    
    func instantiateItemsViewController(category: Category) {
        let storyboard = UIStoryboard(name: "Collector", bundle: nil)
        let itemsViewController = storyboard.instantiateViewController(withIdentifier: "ItemsViewController") as! ListItemViewController
        itemsViewController.categorySelected = category
        navigationController!.pushViewController(itemsViewController, animated: true)
    }
    
    // MARK: - Category Table View Settings
    
    func instantiateCategoriesSettingsView() {
        let views = Bundle.main.loadNibNamed("CategoriesSettingsView", owner: nil, options: nil)
        let categoriesSettingsView = views?.first as! CategoriesSettingsView
        self.categoriesSettings = categoriesSettingsView
        categoriesSettingsView.controller = self
        settingsUIView = categoriesSettingsView
        categoriesSettingsView.frame.size = categoriesViewController!.settingsContainer.frame.size
        categoriesViewController?.settingsContainer.addSubview(categoriesSettingsView)
    }
    
    // MARK: - Category Table View Editing
    
    func instantiateCategoriesEditView() {
        let views = Bundle.main.loadNibNamed("CategoriesEditView", owner: nil, options: nil)
        let categoriesEditView = views?.first as! CategoriesEditView
        categoriesEditView.editTexrField.delegate = categoriesTableViewController
        categoriesEditView.editTexrField.borderDesign()
        categoriesEditView.controller = self
        settingsUIView = categoriesEditView
        categoriesEditView.frame.size = categoriesViewController!.settingsContainer.frame.size
        categoriesViewController?.settingsContainer.addSubview(categoriesEditView)
    }
    
    func categoriesTableViewEditing() {
        categoriesViewController?.tableViewEditing()
        categoriesTableViewController?.tableViewEditing()
    }
    
    func categoriesTableViewEndEditing() {
        categoriesViewController?.tableViewEndEditing()
        categoriesTableViewController?.tableViewEndEditing()
    }
    
    // MARK: - Category Table View Filtering
    
    func instantiateCategoriesFilterView() {
        let views = Bundle.main.loadNibNamed("CategoriesFilterView", owner: nil, options: nil)
        let categoriesFilterView = views?.first as! CategoriesFilterView
        categoriesFilterView.controller = self
        settingsUIView = categoriesFilterView
        categoriesFilterView.frame.size = categoriesViewController!.settingsContainer.frame.size
        categoriesViewController?.settingsContainer.addSubview(categoriesFilterView)
    }
    
    // MARK: - Category Table View Searching
    
    func instantiateCategoriesSearchView() {
        let views = Bundle.main.loadNibNamed("CategoriesSearchView", owner: nil, options: nil)
        let categoriesSearchView = views?.first as! CategoriesSearchView
        categoriesSearchView.searchTextField.delegate = categoriesTableViewController
        categoriesSearchView.searchTextField.borderDesign()
        categoriesSearchView.controller = self
        settingsUIView = categoriesSearchView
        categoriesSearchView.frame.size = categoriesViewController!.settingsContainer.frame.size
        categoriesViewController?.settingsContainer.addSubview(categoriesSearchView)
        categoriesSearchView.searchTextField.becomeFirstResponder()
    }
    
    // MARK: - Category Table View Sorting
    
    func instantiateCategoriesSortView() {
        let views = Bundle.main.loadNibNamed("CategoriesSortView", owner: nil, options: nil)
        let categoriesSortView = views?.first as! CategoriesSortView
        categoriesSortView.sortSegmentedControl.selectedSegmentIndex = categoriesSort.rawValue
        categoriesSortView.controller = self
        settingsUIView = categoriesSortView
        categoriesSortView.frame.size = categoriesViewController!.settingsContainer.frame.size
        categoriesViewController?.settingsContainer.addSubview(categoriesSortView)
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
        let views = Bundle.main.loadNibNamed("CategoriesAddView", owner: nil, options: nil)
        let categoriesAddView = views?.first as! CategoriesAddView
        categoriesAddView.nameCategoryTextField.borderDesign()
        categoriesAddView.controller = self
        settingsUIView = categoriesAddView
        categoriesAddView.frame.size = categoriesViewController!.settingsContainer.frame.size
        categoriesViewController?.settingsContainer.addSubview(categoriesAddView)
        categoriesAddView.nameCategoryTextField.becomeFirstResponder()
    }
    
    // UITextField Functions
    
    func textFieldDidResearching(_ text: String) {
        categoriesTableViewController?.textFieldDidResearching(text)
    }
    
    // MARK: - Remove Container View
    
    func removeSettingsContainer() {
        categoriesViewController?.settingsContainer.subviews.first!.removeFromSuperview()
        settingsUIView = nil
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
        nav?.barTintColor = UIColor(red: 7/255, green: 90/255, blue: 172/255, alpha: 1)
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}
