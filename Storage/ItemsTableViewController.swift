//
//  ItemsTableViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 18/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController {
    
    weak var controller: ItemsController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch controller!.dataAsked {
        case .items:
            return controller!.items.count
        case .filtereditems:
            return controller!.filteredItem.count
        case .researchingitems:
            return controller!.researchingItem.count
        case .titlefeatures:
            return controller!.titleFeatures.count
        case .features:
            return controller!.allFeatures[controller!.titleFeatureSelected]!.count
        case .filtersediting:
            return controller!.filters.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch controller!.dataAsked {
        case .items:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellItem.identifier, for: indexPath) as! CellItem
            let itemCell: Item = controller!.items[indexPath.row]
            cell.thisItem = itemCell
            cell.configureCell(with: itemCell, index: indexPath.row)
            if itemCell.favorites == true {
                cell.colorFavorites()
            } else {
                cell.colorCell()
            }
            return cell
        case .filtereditems:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellItem.identifier, for: indexPath) as! CellItem
            let itemCell: Item = controller!.filteredItem[indexPath.row]
            cell.thisItem = itemCell
            cell.configureCell(with: itemCell, index: indexPath.row)
            if itemCell.favorites == true {
                cell.colorFavorites()
            } else {
                cell.colorCell()
            }
            return cell
        case .researchingitems:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellItem.identifier, for: indexPath) as! CellItem
            let itemCell: Item = controller!.researchingItem[indexPath.row]
            cell.thisItem = itemCell
            cell.configureCell(with: itemCell, index: indexPath.row)
            if itemCell.favorites == true {
                cell.colorFavorites()
            } else {
                cell.colorCell()
            }
            return cell
        case .titlefeatures:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellItemTitleFeatures.identifier, for: indexPath) as! CellItemTitleFeatures
            cell.configureCell(with: controller!.titleFeatures[indexPath.row], index: indexPath.row)
            return cell
        case .features:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellItemFeatures.identifier, for: indexPath) as! CellItemFeatures
            cell.configureCell(with: controller!.allFeatures[controller!.titleFeatureSelected]![indexPath.row], index: indexPath.row)
            return cell
        case .filtersediting:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellFilters.identifier, for: indexPath) as! CellFilters
            cell.configureCell(with: controller!.filters[indexPath.row], index: indexPath.row)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch controller!.dataAsked {
        case .items:
            if tableView.isEditing {
//                updateItem(indexPath: indexPath)
                controller!.itemsSelected.append(controller!.items[indexPath.row])
//                editBar.text = controller!.items[indexPath.row].name
            }
            break
        case .filtereditems:
            if tableView.isEditing {
                controller!.itemsSelected.append(controller!.filteredItem[indexPath.row])
            }
            break
        case .researchingitems:
            break
        case .titlefeatures:
            controller!.titleFeatureSelected = controller!.titleFeatures[indexPath.row]
            controller!.featuresIndex = indexPath.row
            controller!.dataAsked = .features
            tableView.reloadData()
            break
        case .features:
            controller!.filters.append(controller!.allFeatures[controller!.titleFeatureSelected]![indexPath.row])
//            getFilteredItem()
            controller!.dataAsked = .filtereditems
//            updateView()
//            hideSearchView()
            tableView.reloadData()
            break
        case .filtersediting:
            controller!.filtersSelected.append(controller!.filters[indexPath.row])
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if controller!.dataAsked == .items && tableView.isEditing {
//            updateItem(indexPath: indexPath)
            let index = controller!.itemsSelected.firstIndex(of: controller!.items[indexPath.row])!
            controller!.itemsSelected.remove(at: index)
//            editBar.text = ""
        }
        if controller!.dataAsked == .filtersediting {
            let index = controller!.filtersSelected.firstIndex(of: controller!.filters[indexPath.row])!
            controller!.filtersSelected.remove(at: index)
        }
    }

}
