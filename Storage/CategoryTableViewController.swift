//
//  CategoryTableViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 30/04/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    var controller: CategoryController?
    var category: [Category] = []

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
        return category.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier(), for: indexPath) as! CategoryCell

        let categoryCell: Category
        //if searchActive {
            //categoryCell = filteredCategory[indexPath.row]
            //cell.thisCategory = filteredCategory[indexPath.row]
        //} else {
            categoryCell = category[indexPath.row]
            cell.thisCategory = category[indexPath.row]
        //}
        cell.configureCell(with: categoryCell, index: indexPath.row)
        if categoryCell.favorites == true {
            cell.colorFavorites()
        } else {
            cell.colorCell()
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        controller?.instantiateItemsViewController(category: category[indexPath.row])
    }
    
    // MARK: - Controller Functions
    
    func reloadData() {
        tableView.reloadData()
    }

}
