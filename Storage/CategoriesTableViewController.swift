//
//  CategoriesTableViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 30/04/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController, UITextFieldDelegate {
    
    weak var delegate: CategoriesTableViewControllerDelegate?
    
    private let categoryList = CategoryList()
    
    var categories: [Category] = []
    var filteredCategories: [Category] = []
    var selectedCategories: [Category] = []
    var categoriesSort: Sort = .increasing
    var modify: Bool = false
    var searchActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filteredCategories.count
        } else {
            return categories.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        var category: Category?
        if searchActive {
            category = filteredCategories[indexPath.row]
        } else {
            category = categories[indexPath.row]
        }
        cell.configureCell(category!)
        cell.index = indexPath.row
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if modify {
            selectedCategories.append(categories[indexPath.row])
        } else {
            delegate?.newItemsViewController(categories[indexPath.row])
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard modify else { return }
        let index = selectedCategories.firstIndex(of: categories[indexPath.row])
        guard index != nil else { return }
        selectedCategories.remove(at: index!)
    }
    
    // MARK: - Controller Functions
    
    func scrolling(row: Int) {
        self.tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: row, section: 0), at: .none, animated: true)
    }
}

protocol CategoryCellDelegate: AnyObject {
    func updateFavorite(_ row: Int)
}

extension CategoriesTableViewController: CategoryCellDelegate {
    func updateFavorite(_ row: Int) {
        let category = categories[row]
        categoryList.updateFavorite(categories[row])
        categories[row].favorite = !category.favorite
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
    }
}

// MARK: - CategoriesViewControllerDelegate

protocol CategoriesViewControllerDelegate: AnyObject {
    func reloadData()
    func categoriesSort(_ sort: Sort)
    func tableViewCategoriesSort() -> Sort
    func addCategories(_ name: String?)
    func removeCategories()
    func textFieldDidBeginEditing()
    func textFieldDidEndEditing()
    func textFieldDidResearching(_ text: String)
    func tableViewEditing()
    func tableViewEndEditing()
}

extension CategoriesTableViewController: CategoriesViewControllerDelegate {
    
    func reloadData() {
        categories = categoriesSort.sort(categoryList.all())
        tableView.reloadData()
    }
    
    // MARK: - Categories Functions
    
    func categoriesSort(_ sort: Sort) {
        categoriesSort = sort
        categories = categoriesSort.sort(categories)
        tableView.reloadData()
    }
    
    func tableViewCategoriesSort() -> Sort {
        return categoriesSort
    }
    
    func addCategories(_ name: String?) {
        categories = categoryList.add(name ?? "")
        tableView.reloadData()
    }
    
    func removeCategories() {
        let categories = categoryList.remove(selectedCategories)
        self.categories = categories
        tableView.reloadData()
    }
    
    // MARK: - Search Functions
    
    func textFieldDidBeginEditing() {
        searchActive = true
        filteredCategories = categories
    }
    
    func textFieldDidEndEditing() {
        searchActive = false
    }
    
    func textFieldDidResearching(_ text: String) {
        if text == "" {
            filteredCategories = categories
        } else {
            filteredCategories = categories.filter({ (results) -> Bool in
                return results.name.lowercased().contains(text.lowercased())
            })
        }
        tableView.reloadData()
    }
    
    func tableViewEditing() {
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(true, animated: true)
        tableView.layoutMargins = UIEdgeInsets.init(top: 0, left: 40, bottom: 0, right: 0)
        modify = true
    }
    
    func tableViewEndEditing() {
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.setEditing(false, animated: false)
        tableView.layoutMargins = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0)
        modify = false
        tableView.reloadData()
    }
}
