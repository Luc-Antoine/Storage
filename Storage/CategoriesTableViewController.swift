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
    
    var categories: [Category] = []
    var researchingCategories: [Category] = []
    var selectedCategories: [Category] = []
    var categoriesSort: Sort = .increasing
    var modify: Bool = false
    var research: Research?
    var lastIndexPath: IndexPath? {
        didSet {
            delegate?.categorySelected(lastIndexPath == nil ? nil : categories[lastIndexPath!.row])
        }
    }
    
    private let categoryList = CategoryList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = categoriesSort.sort(categoryList.all())
        if research != nil {
            textFieldDidResearching(research!.search)
        } else {
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if research != nil {
            return researchingCategories.count
        } else {
            return categories.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        var category: Category?
        if research != nil {
            category = researchingCategories[indexPath.row]
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
            lastIndexPath = indexPath
            delegate?.editTextField(categories[indexPath.row].name)
        } else {
            if research != nil {
                delegate?.newItemsViewController(researchingCategories[indexPath.row])
            } else {
                delegate?.newItemsViewController(categories[indexPath.row])
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        lastIndexPath = nil
        delegate?.editTextFieldEndEditing()
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
    func selectCategory(_ index: Int)
    func reloadCategory(_ category: Category)
}

extension CategoriesTableViewController: CategoryCellDelegate {
    func updateFavorite(_ row: Int) {
        let category = categories[row]
        categoryList.updateFavorite(category)
        categories[row].favorite = !category.favorite
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
    
    func selectCategory(_ index: Int) {
        lastIndexPath = IndexPath(row: index, section: 0)
    }
    
    func reloadCategory(_ category: Category) {
        guard lastIndexPath != nil else { return }
        if categories.indices.contains(lastIndexPath!.row) {
            categories[lastIndexPath!.row] = category
        } else {
            categories.append(category)
        }
        tableView!.reloadRows(at: [lastIndexPath!], with: .automatic)
    }
}

// MARK: - CategoriesViewControllerDelegate

protocol CategoriesViewControllerDelegate: AnyObject {
    func reloadData()
    func categoriesSort(_ sort: Sort)
    func tableViewCategoriesSort() -> Sort
    func addCategories(_ name: String?)
    func update(_ name: String) -> Bool
    func removeCategories()
    func textFieldDidBeginResearching()
    func textFieldDidEndResearching()
    func textFieldDidResearching(_ text: String)
    func searchCount() -> Int
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
        researchingCategories = categoriesSort.sort(researchingCategories)
        tableView.reloadData()
    }
    
    func tableViewCategoriesSort() -> Sort {
        return categoriesSort
    }
    
    func addCategories(_ name: String?) {
        categories = categoryList.add(name ?? "")
        tableView.reloadData()
    }
    
    func update(_ name: String) -> Bool {
        guard lastIndexPath != nil else { return false }
        var category = categories[lastIndexPath!.row]
        category.name = name
        categories[lastIndexPath!.row] = category
        categoryList.updateName(category)
        tableView.reloadRows(at: [lastIndexPath!], with: .none)
        lastIndexPath = nil
        return true
    }
    
    func removeCategories() {
        let categories = categoryList.remove(selectedCategories)
        self.categories = categories
        tableView.reloadData()
    }
    
    // MARK: - Search Functions
    
    func textFieldDidBeginResearching() {
        research = Research.init(search: "", count: 0)
        researchingCategories = categories
    }
    
    func textFieldDidEndResearching() {
        research = nil
        tableView.reloadData()
    }
    
    func textFieldDidResearching(_ text: String) {
        if text == "" {
            researchingCategories = categories
        } else {
            researchingCategories = categories.filter({ (results) -> Bool in
                return results.name.lowercased().contains(text.lowercased())
            })
        }
        tableView.reloadData()
    }
    
    func searchCount() -> Int {
        return researchingCategories.count
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
        lastIndexPath = nil
        tableView.reloadData()
    }
}
