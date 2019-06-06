//
//  CategoriesTableViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 30/04/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController, UITextFieldDelegate {
    
    var controller: CategoriesController?
    var categories: [Category] = []
    var filteredCategories: [Category] = []
    var modify: Bool = false
    var searchActive: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier(), for: indexPath) as! CategoryCell

        let categoryCell: Category
        if searchActive {
            categoryCell = filteredCategories[indexPath.row]
            cell.thisCategory = filteredCategories[indexPath.row]
        } else {
            categoryCell = categories[indexPath.row]
            cell.thisCategory = categories[indexPath.row]
        }
        cell.configureCell(with: categoryCell, index: indexPath.row)
        if categoryCell.favorites == true {
            cell.colorFavorites()
        } else {
            cell.colorCell()
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if modify {
            controller?.selectedCategories.append(categories[indexPath.row])
        } else {
            controller?.instantiateItemsViewController(category: categories[indexPath.row])
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard modify else { return }
        let index = controller?.selectedCategories.firstIndex(of: categories[indexPath.row])
        guard index != nil else { return }
        controller?.selectedCategories.remove(at: index!)
    }
    
    // MARK: - Search Functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchActive = true
        filteredCategories = categories
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchActive = false
    }
    
    func textFieldDidResearching(_ text: String) {
        if text == "" {
            filteredCategories = categories
        } else {
            filteredCategories = categories.filter({ (results) -> Bool in
                return results.name!.lowercased().contains(text.lowercased())
            })
        }
        tableView.reloadData()
    }
    
    func endResearching() {
        filteredCategories.removeAll()
        tableView.reloadData()
    }
    
    // MARK: - Controller Functions
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func scrolling(row: Int) {
        self.tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: row, section: 0), at: .none, animated: true)
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
