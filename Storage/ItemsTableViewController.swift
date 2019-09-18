//
//  ItemsTableViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 18/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

enum KindItem {
    case items, filteredItems, researchingItems, nameFeatures, features, filtersEditing
}

class ItemsTableViewController: UITableViewController {
    
    weak var delegate: ItemsTableViewControllerDelegate?
    
    var category: Category?
    var kindItem: KindItem = .items
    var items: [Item] = []
    var filteredItems: [Item] = []
    var selectedItems: [Item] = []
    var researchingItems: [Item] = []
    var nameFeatures: [NameFeature] = []
    var nameFeaturesFiltered: [NameFeature] = []
    var features: [Feature] = []
    var featuresFilteredByItem: [Feature] = []
    var featuresFilteredByName: [Feature] = []
    var featuresFiltered: [Feature] = []
    var itemsSort: Sort = .increasing
    var modify: Bool = false
    var searchActive: Bool = false
    
    private let itemsList = ItemList()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadItems()
        loadNameFeatures()
        loadFeatures()
        reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch kindItem {
        case .items:
            return items.count
        case .filteredItems:
            return filteredItems.count
        case .researchingItems:
            return researchingItems.count
        case .nameFeatures:
            return nameFeatures.count
        case .features:
            return featuresFilteredByName.count
        case .filtersEditing:
            return featuresFiltered.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch kindItem {
        case .items:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.identifier, for: indexPath) as! ItemCell
            cell.configureCell(items[indexPath.row])
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        case .filteredItems:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.identifier, for: indexPath) as! ItemCell
            cell.configureCell(filteredItems[indexPath.row])
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        case .researchingItems:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.identifier, for: indexPath) as! ItemCell
            cell.configureCell(researchingItems[indexPath.row])
            cell.delegate = self
            return cell
        case .nameFeatures:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemNameFeaturesCell.identifier, for: indexPath) as! ItemNameFeaturesCell
            cell.configureCell(nameFeatures[indexPath.row])
            if nameFeaturesFiltered.contains(nameFeatures[indexPath.row]) {
                cell.select()
            } else {
                cell.unselect()
            }
            return cell
        case .features:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemFeaturesCell.identifier, for: indexPath) as! ItemFeaturesCell
            cell.configureCell(featuresFilteredByName[indexPath.row])
            if featuresFilteredByItem.contains(featuresFilteredByName[indexPath.row]) {
                cell.select()
            } else {
                cell.unselect()
            }
            return cell
        case .filtersEditing:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemFiltersCell.identifier, for: indexPath) as! ItemFiltersCell
            cell.configureCell(featuresFiltered[indexPath.row])
            if featuresFiltered.contains(featuresFiltered[indexPath.row]) {
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
        let navBarItemFilter = delegate?.navBarItemFilterOption()
        switch kindItem {
        case .items:
            if navBarItemFilter == .delete {
                selectedItems.append(items[indexPath.row])
            }
            if navBarItemFilter == .add {
                delegate?.newFeaturesViewController(items[indexPath.row])
            }
            break
        case .filteredItems:
            if navBarItemFilter == .delete {
                selectedItems.append(filteredItems[indexPath.row])
            }
            if navBarItemFilter == .add {
                delegate?.newFeaturesViewController(filteredItems[indexPath.row])
            }
            break
        case .researchingItems:
            break
        case .nameFeatures:
            nameFeaturesFiltered = nameFeaturesFiltered.set(nameFeatures[indexPath.row])
            tableView.reloadRows(at: [indexPath], with: .automatic)
            break
        case .features:
            featuresFilteredByItem = featuresFilteredByItem.set(featuresFilteredByName[indexPath.row])
            featuresFiltered = featuresFiltered.set(featuresFilteredByName[indexPath.row])
            tableView.reloadRows(at: [indexPath], with: .automatic)
            break
        case .filtersEditing:
            featuresFilteredByItem = featuresFilteredByItem.set(featuresFilteredByItem[indexPath.row])
            featuresFiltered = featuresFiltered.set(featuresFiltered[indexPath.row])
            
            var nameFeatureIdInFeaturesFiltered: [Int] = []
            for feature in featuresFiltered {
                nameFeatureIdInFeaturesFiltered.append(feature.featureId)
            }
            nameFeatureIdInFeaturesFiltered = nameFeatureIdInFeaturesFiltered.removeDuplicates()
            
            nameFeaturesFiltered.removeAll { (results) -> Bool in
                !nameFeatureIdInFeaturesFiltered.contains(results.id)
            }
            
            featuresFilteredByName.removeAll { (results) -> Bool in
                !nameFeatureIdInFeaturesFiltered.contains(results.id)
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            break
        }
    }
    
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        switch kindItem {
//        case .items:
//            if controller!.isEditing {
////            updateItem(indexPath: indexPath)
//                let index = controller!.itemsSelected.firstIndex(of: controller!.items[indexPath.row])
//                guard index != nil else { return }
//                controller!.itemsSelected.remove(at: index!)
////            editBar.text = ""
//            }
//            break
//        case .filteredItems:
//            break
//        case .researchingItems:
//            break
//        case .nameFeatures:
//            let index = controller!.nameFeaturesFiltered.firstIndex(of: controller!.nameFeatures[indexPath.row])
//            guard index != nil else { return }
//            controller!.nameFeaturesFiltered.remove(at: index!)
//            break
//        case .features:
//            controller!.featuresFilteredByItem = controller!.featuresFilteredByItem.set(controller!.featuresFilteredByName[indexPath.row])
//            tableView.reloadRows(at: [indexPath], with: .automatic)
//            break
//        case .filtersEditing:
////            let index = controller!.filtersSelected.firstIndex(of: controller!.filters[indexPath.row])!
////            controller!.filtersSelected.remove(at: index)
//            break
//        }
//    }
    
    // MARK: - Filter Functions
    
    func loadItems() {
        items = itemsSort.sort(itemsList.all(category!.id))
    }
    
    func loadNameFeatures() {
        nameFeatures = itemsList.all(category!.id)
    }
    
    func loadFeatures() {
        features = itemsList.all(items)
    }
    
    func filterFeatures() {
        guard nameFeaturesFiltered.count > 0 else { return }
        for nameFeature in nameFeaturesFiltered {
            featuresFilteredByName.append(contentsOf: features.filter({ $0.nameFeatureId == nameFeature.id }))
        }
        featuresFilteredByName = featuresFilteredByName.removeDuplicates()
    }
    
    func filterItems() {
        filteredItems.removeAll()
        for feature in featuresFilteredByItem {
            filteredItems.append(contentsOf: items.filter({ $0.id == feature.itemId }))
        }
        filteredItems = filteredItems.removeDuplicates()
    }
    
    func filters() {
        switch kindItem {
        case .items:
            break
        case .filteredItems:
            break
        case .researchingItems:
            break
        case .nameFeatures:
            filterFeatures()
            kindItem = .features
            tableView.reloadData()
            break
        case .features:
            filterItems()
            kindItem = .filteredItems
            tableView.reloadData()
            break
        case .filtersEditing:
            filterItems()
            kindItem = .nameFeatures
            tableView.reloadData()
            break
        }
    }
    
    func removeFilters() {
        filteredItems.removeAll()
        nameFeaturesFiltered.removeAll()
        featuresFilteredByItem.removeAll()
        featuresFilteredByName.removeAll()
    }
}



extension ItemsTableViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldDidBeginEditing()
        tableView.reloadData()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDidEndEditing()
    }
}

protocol ItemDelegate {
    func updateFavorite(_ row: Int)
}

extension ItemsTableViewController: ItemDelegate {
    func updateFavorite(_ row: Int) {
        itemsList.updateFavorite(items[row])
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
    }
}

// MARK: - ItemsViewControllerDelegate

protocol ItemsViewControllerDelegate: AnyObject {
    func reloadData()
    func itemsSort(_ sort: Sort)
    func tableViewItemsSort() -> Sort
    func addItem(_ name: String?)
    func removeItems()
    func textFieldDidBeginEditing()
    func textFieldDidEndEditing()
    func textFieldDidResearching(_ text: String)
    func tableViewEditing()
    func tableViewEndEditing()
    func kindItem(_ kind: KindItem)
    func tableViewKindItem() -> KindItem
    func featuresFilteredByItemCount() -> Int
    func filter()
    func filters()
    func resetFilters()
}

extension ItemsTableViewController: ItemsViewControllerDelegate {
    
    func reloadData() {
        loadItems()
        tableView.reloadData()
    }
    
    // MARK: - Items Functions
    
    func itemsSort(_ sort: Sort) {
        itemsSort = sort
        items = itemsSort.sort(items)
        tableView.reloadData()
    }
    
    func tableViewItemsSort() -> Sort {
        return itemsSort
    }
    
    func addItem(_ name: String?) {
        items = itemsList.add(name ?? "", category!.id)
        tableView.reloadData()
    }
    
    func removeItems() {
        let items = itemsList.removeItems(selectedItems, category!.id)
        self.items = items
        tableView.reloadData()
    }
    
    // MARK: - Search Functions
    
    func textFieldDidBeginEditing() {
        searchActive = true
        filteredItems = items
    }
    
    func textFieldDidEndEditing() {
        searchActive = false
    }
    
    func textFieldDidResearching(_ text: String) {
        if text == "" {
            researchingItems = items
        } else {
            researchingItems = items.filter({ (results) -> Bool in
                return results.name.lowercased().contains(text.lowercased())
            })
        }
        tableView.reloadData()
    }
    
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
    
    // MARK: - Filter Functions
    
    func kindItem(_ kind: KindItem) {
        kindItem = kind
    }
    
    func tableViewKindItem() -> KindItem {
        return kindItem
    }
    
    func featuresFilteredByItemCount() -> Int {
        return featuresFilteredByItem.count
    }
    
    func filter() {
        if filteredItems.count > 0 {
            kindItem(.filtersEditing)
        } else {
            kindItem(.nameFeatures)
        }
        tableView.reloadData()
        //filters()
    }
    
    func resetFilters() {
        removeFilters()
        kindItem = .items
        tableView.reloadData()
    }
}
