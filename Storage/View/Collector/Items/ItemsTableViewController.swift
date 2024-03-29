//
//  ItemsTableViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 18/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

enum KindItem {
    case items, filteredItems, nameFeatures, features, filtersEditing
}

class ItemsTableViewController: UITableViewController {
    
    weak var delegate: ItemsTableViewControllerDelegate?
    
    var category: Category?
    var kindItem: KindItem = .items
    var items: [Item] = []
    var filteredItems: [Item] = []
    var selectedItems: [Item] = []
    var nameFeatures: [NameFeature] = []
    var nameFeaturesFiltered: [NameFeature] = []
    var features: [Feature] = []
    var featuresFilteredByItem: [Feature] = []
    var featuresFilteredByName: [Feature] = []
    var featuresFiltered: [Feature] = []
    var itemsSort: Sort = .increasing
    var modify: Bool = false
    var lastIndexPath: IndexPath? {
        didSet {
            delegate?.itemSelected(lastIndexPath == nil ? nil : items[lastIndexPath!.row])
        }
    }
    
    private let itemsList = ItemList()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navBarItemFilter = delegate?.navBarItemFilterOption()
        switch kindItem {
        case .items:
            if navBarItemFilter == .delete {
                let itemSelected = items[indexPath.row]
                selectedItems.append(itemSelected)
                lastIndexPath = indexPath
                delegate?.editTextField(items[indexPath.row].name)
            } else {
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
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let index = selectedItems.firstIndex(of: items[indexPath.row]) {
            selectedItems.remove(at: index)
        }
        lastIndexPath = nil
        delegate?.editTextFieldEndEditing()
    }
    
    // MARK: - DataBase Functions
    
    func loadItems() {
        items = itemsSort.sort(itemsList.all(category!.id))
    }
    
    func loadNameFeatures() {
        nameFeatures = itemsList.all(category!.id)
    }
    
    func loadFeatures() {
        features = itemsList.all(items)
    }
    
    // MARK: - Filter Functions
    
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
        featuresFiltered.removeAll()
    }
}

// MARK: - ItemCellDelegate

protocol ItemCellDelegate {
    func updateFavorite(_ row: Int)
}

extension ItemsTableViewController: ItemCellDelegate {
    
    func updateFavorite(_ row: Int) {
        let item = items[row]
        itemsList.updateFavorite(item)
        items[row].favorite = !item.favorite
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
}

// MARK: - ItemFeaturesCellDelegate

protocol ItemFeaturesCellDelegate: AnyObject {
    func selectItem(_ index: Int)
    func reloadItem(_ item: Item)
}

extension ItemsTableViewController: ItemFeaturesCellDelegate {
    
    func selectItem(_ index: Int) {
        lastIndexPath = IndexPath(row: index, section: 0)
    }
    
    func reloadItem(_ item: Item) {
        guard lastIndexPath != nil else { return }
        if features.indices.contains(lastIndexPath!.row) {
            items[lastIndexPath!.row] = item
        } else {
            items.append(item)
        }
        tableView!.reloadRows(at: [lastIndexPath!], with: .automatic)
    }
}

// MARK: - ItemsViewControllerDelegate

protocol ItemsViewControllerDelegate: AnyObject {
    func reloadData()
    func itemsSort(_ sort: Sort)
    func tableViewItemsSort() -> Sort
    func addItem(_ name: String?)
    func update(_ name: String) -> Bool
    func removeItems()
    func tableViewEditing()
    func tableViewEndEditing()
    func kindItem(_ kind: KindItem)
    func tableViewKindItem() -> KindItem?
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
        itemsSort(itemsSort)
        tableView.reloadData()
    }
    
    func update(_ name: String) -> Bool {
        guard lastIndexPath != nil else { return false }
        var item = items[lastIndexPath!.row]
        item.name = name
        items[lastIndexPath!.row] = item
        itemsList.updateName(item)
        tableView.reloadRows(at: [lastIndexPath!], with: .none)
        lastIndexPath = nil
        return true
    }
    
    func removeItems() {
        let items = itemsList.removeItems(selectedItems, nameFeatures, category!.id)
        self.items = items
        itemsSort(itemsSort)
        tableView.reloadData()
    }
    
    func tableViewEditing() {
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(true, animated: true)
        tableView.layoutMargins = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 0)
    }
    
    func tableViewEndEditing() {
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.setEditing(false, animated: false)
        tableView.layoutMargins = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 0)
        lastIndexPath = nil
        tableView.reloadData()
    }
    
    // MARK: - Filter Functions
    
    func kindItem(_ kind: KindItem) {
        kindItem = kind
    }
    
    func tableViewKindItem() -> KindItem? {
        switch kindItem {
        case .items:
            break
        case .filteredItems:
            break
        case .nameFeatures:
            if nameFeaturesFiltered.count == 0 {
                return nil
            }
            break
        case .features:
            if featuresFilteredByItem.count == 0 {
                return nil
            }
            break
        case .filtersEditing:
            break
        }
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
    }
    
    func resetFilters() {
        removeFilters()
        kindItem = .items
        tableView.reloadData()
    }
}
