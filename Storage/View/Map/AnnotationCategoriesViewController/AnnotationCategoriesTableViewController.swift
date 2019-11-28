//
//  AnnotationCategoriesTableViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 26/11/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class AnnotationCategoriesTableViewController: UITableViewController {
    
    weak var delegate: AnnotationCategoriesDelegate?
    
    var categories: [Category] = []
    var categoriesSelected: [Int] = []
    
    private let categoryList = CategoryList()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Categories", comment: "") 
        categories = categoryList.all()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.update(categoriesSelected)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AnnotationCategoriesTableViewCell.identifier, for: indexPath) as! AnnotationCategoriesTableViewCell
        let category = categories[indexPath.row]
        cell.configureCell(category)
        if categoriesSelected.contains(category.id) {
            cell.select()
        } else {
            cell.unselect()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        if let index = categoriesSelected.firstIndex(of: category.id) {
            categoriesSelected.remove(at: index)
        } else {
            categoriesSelected.append(category.id)
        }
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

// MARK: - AnnotationCategoriesToAnnotationsViewControllerDelegate

extension AnnotationCategoriesTableViewController: AnnotationCategoriesToAnnotationsViewControllerDelegate {
    func categoriesFiltered() -> [Int] {
        return categoriesSelected
    }
}
