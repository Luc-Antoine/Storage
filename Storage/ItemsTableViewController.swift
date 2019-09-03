//
//  ItemsTableViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 18/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

protocol ItemDelegate {
    func updateFavorite(_ row: Int)
}

class ItemsTableViewController: UITableViewController {
    
    weak var controller: ItemsController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch controller!.kindItem {
        case .items:
            return controller!.items.count
        case .filteredItems:
            return controller!.itemsFiltered.count
        case .researchingItems:
            return controller!.researchingItems.count
        case .nameFeatures:
            return controller!.nameFeatures.count
        case .features:
            return controller!.featuresFilteredByName.count
        case .filtersEditing:
            return controller!.featuresFiltered.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch controller!.kindItem {
        case .items:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.identifier, for: indexPath) as! ItemCell
            cell.configureCell(controller!.items[indexPath.row])
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        case .filteredItems:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.identifier, for: indexPath) as! ItemCell
            cell.configureCell(controller!.itemsFiltered[indexPath.row])
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        case .researchingItems:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.identifier, for: indexPath) as! ItemCell
            cell.configureCell(controller!.researchingItems[indexPath.row])
            cell.delegate = self
            return cell
        case .nameFeatures:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemNameFeaturesCell.identifier, for: indexPath) as! ItemNameFeaturesCell
            cell.configureCell(controller!.nameFeatures[indexPath.row])
            if controller!.nameFeaturesFiltered.contains(controller!.nameFeatures[indexPath.row]) {
                cell.select()
            } else {
                cell.unselect()
            }
            return cell
        case .features:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemFeaturesCell.identifier, for: indexPath) as! ItemFeaturesCell
            cell.configureCell(controller!.featuresFilteredByName[indexPath.row])
            if controller!.featuresFilteredByItem.contains(controller!.featuresFilteredByName[indexPath.row]) {
                cell.select()
            } else {
                cell.unselect()
            }
            return cell
        case .filtersEditing:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemFiltersCell.identifier, for: indexPath) as! ItemFiltersCell
            cell.configureCell(controller!.featuresFiltered[indexPath.row])
            if controller!.featuresFiltered.contains(controller!.featuresFiltered[indexPath.row]) {
                cell.select()
            } else {
                cell.unselect()
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch controller!.kindItem {
        case .items:
            if controller!.navBarItemFilter == .delete {
                controller!.itemsSelected.append(controller!.items[indexPath.row])
            }
            if controller!.navBarItemFilter == .add {
                controller!.instantiateFeaturesController(controller!.items[indexPath.row])
            }
            break
        case .filteredItems:
            if controller!.navBarItemFilter == .delete {
                controller!.itemsSelected.append(controller!.itemsFiltered[indexPath.row])
            }
            if controller!.navBarItemFilter == .add {
                controller!.instantiateFeaturesController(controller!.itemsFiltered[indexPath.row])
            }
            break
        case .researchingItems:
            break
        case .nameFeatures:
            controller!.nameFeaturesFiltered = controller!.nameFeaturesFiltered.set(controller!.nameFeatures[indexPath.row])
            tableView.reloadRows(at: [indexPath], with: .automatic)
            break
        case .features:
            controller!.featuresFilteredByItem = controller!.featuresFilteredByItem.set(controller!.featuresFilteredByName[indexPath.row])
            controller!.featuresFiltered = controller!.featuresFiltered.set(controller!.featuresFilteredByName[indexPath.row])
            tableView.reloadRows(at: [indexPath], with: .automatic)
            break
        case .filtersEditing:
            controller!.featuresFilteredByItem = controller!.featuresFilteredByItem.set(controller!.featuresFilteredByName[indexPath.row])
            controller!.featuresFiltered = controller!.featuresFiltered.set(controller!.featuresFilteredByName[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        switch controller!.kindItem {
        case .items:
            if controller!.isEditing {
//            updateItem(indexPath: indexPath)
                let index = controller!.itemsSelected.firstIndex(of: controller!.items[indexPath.row])
                guard index != nil else { return }
                controller!.itemsSelected.remove(at: index!)
//            editBar.text = ""
            }
            break
        case .filteredItems:
            break
        case .researchingItems:
            break
        case .nameFeatures:
            let index = controller!.nameFeaturesFiltered.firstIndex(of: controller!.nameFeatures[indexPath.row])
            guard index != nil else { return }
            controller!.nameFeaturesFiltered.remove(at: index!)
            break
        case .features:
            controller!.featuresFilteredByItem = controller!.featuresFilteredByItem.set(controller!.featuresFilteredByName[indexPath.row])
            tableView.reloadRows(at: [indexPath], with: .automatic)
            break
        case .filtersEditing:
//            let index = controller!.filtersSelected.firstIndex(of: controller!.filters[indexPath.row])!
//            controller!.filtersSelected.remove(at: index)
            break
        }
    }
    
    // MARK - Controller Functions
    
    func tableViewEditing() {
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(true, animated: true)
        tableView.layoutMargins = UIEdgeInsets.init(top: 0, left: 40, bottom: 0, right: 0)
    }
    
    func tableViewEndEditing() {
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.setEditing(false, animated: false)
        tableView.layoutMargins = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0)
        tableView.reloadData()
    }

}

extension ItemsTableViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        controller!.textFieldDidBeginEditing()
        tableView.reloadData()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        controller!.textFieldDidEndEditing()
    }
}

extension ItemsTableViewController: ItemDelegate {
    func updateFavorite(_ row: Int) {
        controller!.updateFavorite(controller!.items[row])
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
    }
}
