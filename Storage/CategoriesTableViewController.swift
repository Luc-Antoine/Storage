//
//  CategoriesTableViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 30/04/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

protocol CategoryDelegate: AnyObject {
    func updateFavorite(_ row: Int)
}

class CategoriesTableViewController: UITableViewController, UITextFieldDelegate {
    
    weak var controller: CategoriesController?

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if controller!.searchActive {
            return controller!.filteredCategories.count
        } else {
            return controller!.categories.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        var category: Category?
        if controller!.searchActive {
            category = controller!.filteredCategories[indexPath.row]
        } else {
            category = controller!.categories[indexPath.row]
        }
        cell.configureCell(category!)
        cell.index = indexPath.row
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if controller!.modify {
            controller?.selectedCategories.append(controller!.categories[indexPath.row])
        } else {
            controller?.instantiateItemsViewController(category: controller!.categories[indexPath.row])
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard controller!.modify else { return }
        let index = controller?.selectedCategories.firstIndex(of: controller!.categories[indexPath.row])
        guard index != nil else { return }
        controller?.selectedCategories.remove(at: index!)
    }
    
    // MARK: - Search Functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        controller!.searchActive = true
        controller!.filteredCategories = controller!.categories
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        controller!.searchActive = false
    }
    
    func textFieldDidResearching(_ text: String) {
        if text == "" {
            controller!.filteredCategories = controller!.categories
        } else {
            controller!.filteredCategories = controller!.categories.filter({ (results) -> Bool in
                return results.name.lowercased().contains(text.lowercased())
            })
        }
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
        controller!.modify = true
    }
    
    func tableViewEndEditing() {
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.setEditing(false, animated: false)
        tableView.layoutMargins = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0)
        controller!.modify = false
        tableView.reloadData()
    }

}

extension CategoriesTableViewController: CategoryDelegate {
    func updateFavorite(_ row: Int) {
        controller!.updateFavorite(controller!.categories[row])
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
    }
}
