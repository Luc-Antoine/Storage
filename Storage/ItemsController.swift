//
//  ItemsController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 06/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class ItemsController: UIController {
    
    weak var itemsViewController: ItemsViewController?
    weak var itemsTableViewContoller: ItemsTableViewController?
    weak var itemsSettingsView: ItemsSettingsView?
    
    enum KindItem {
        case items, filteredItems, researchingItems, nameFeatures, features, filtersEditing
    }
    
    var kindItem: KindItem = .items
    var navBarItemFilter: NavBarItemFilter? = .add
    var items: [Item] = []
    var nameFeatures: [NameFeature] = []
    var nameFeaturesFiltered: [NameFeature] = []
    var features: [Feature] = []
    var featuresFilteredByItem: [Feature] = []
    var featuresFilteredByName: [Feature] = []
    var featuresFiltered: [Feature] = []
    var itemsSelected: [Item] = []
    var itemsFiltered: [Item] = []
    var researchingItems: [Item] = []
    
    var category: Category?
    var itemSort: Sort = .increasing
    var isEditing: Bool = false
    var searchActive: Bool = false
    var viewHeight: CGFloat = 0
    var settingSegmentedIndex: Int = 3
    var featuresIndex: Int = 0
    
    var filtersSelected: [String] = []
    
    internal let dataBase = DataBase()
    
    // MARK: - Edit Function
    
    func itemsTableViewEditing() {
        itemsTableViewContoller!.tableViewEditing()
    }
    
    func itemsTableViewEndEditing() {
        itemsTableViewContoller!.tableViewEndEditing()
    }
    
    // MARK: - Sort Function
    
    func sortItem() {
        if itemsFiltered.count > 0 {
            switch itemSort {
            case .increasing:
                itemsFiltered = itemsFiltered.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
                break
            case .decreasing:
                itemsFiltered = itemsFiltered.sorted(by: { $0.name.lowercased() > $1.name.lowercased() })
                break
            case .favoritesFirst:
                itemsFiltered = itemsFiltered.sorted(by: { $0.favorite && !$1.favorite })
                break
            case .favoritesLast:
                itemsFiltered = itemsFiltered.sorted(by: { !$0.favorite && $1.favorite })
                break
            }
        } else {
            switch itemSort {
            case .increasing:
                items = items.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
                break
            case .decreasing:
                items = items.sorted(by: { $0.name.lowercased() > $1.name.lowercased() })
                break
            case .favoritesFirst:
                items = items.sorted(by: { $0.favorite && !$1.favorite })
                break
            case .favoritesLast:
                items = items.sorted(by: { !$0.favorite && $1.favorite })
                break
            }
        }
        itemsTableViewContoller?.tableView.reloadData()
    }
    
    // MARK: - Search Functions
    
    func textFieldDidBeginEditing() {
        kindItem = .researchingItems
        researchingItems = items
    }
    
    func textFieldDidEndEditing() {
        kindItem = .items
    }
    
    func textFieldDidResearching(_ text: String) {
        if text == "" {
            researchingItems = items
        } else {
            researchingItems = items.filter({ (results) -> Bool in
                return results.name.lowercased().contains(text.lowercased())
            })
        }
        itemsTableViewContoller!.tableView.reloadData()
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
        itemsFiltered.removeAll()
        for feature in featuresFilteredByItem {
            itemsFiltered.append(contentsOf: items.filter({ $0.id == feature.itemId }))
        }
        itemsFiltered = itemsFiltered.removeDuplicates()
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
            itemsTableViewContoller!.tableView.reloadData()
            break
        case .features:
            filterItems()
            kindItem = .filteredItems
            itemsTableViewContoller!.tableView.reloadData()
            setFilters()
            break
        case .filtersEditing:
            filterItems()
            kindItem = .filteredItems
            itemsTableViewContoller!.tableView.reloadData()
            setFilters()
            break
        }
    }
    
    func setFilters() {
        removeSettingsContainer()
        instantiateItemsSettingsView()
    }
    
    func resetFilters() {
        removeFilters()
        kindItem = .items
        itemsTableViewContoller!.tableView.reloadData()
    }
    
    func removeFilters() {
        itemsFiltered.removeAll()
        nameFeaturesFiltered.removeAll()
        featuresFilteredByItem.removeAll()
        featuresFilteredByName.removeAll()
    }
    
    // Data Base Functions
    
    func select() {
        items = dataBase.select(category!.id)
        nameFeatures = dataBase.select(category!.id)
        features = dataBase.select(itemsId: items.map({ String($0.id) }).joined(separator: ","))
        sortItem()
    }
    
    func updateFavorite(_ item: Item) {
        dataBase.update(item)
        let index = items.firstIndex(where: { $0.id == item.id })
        guard index != nil else { return }
        items[index!].favorite = !item.favorite
    }
    
    func add(_ itemName: String) {
        guard itemName != "" else { return }
        dataBase.insert(Item(id: 0, name: itemName, categoryId: category!.id, favorite: false))
        select()
    }
    
    func removeItems(_ items: [Item]) {
        guard items.count > 0 else { return }
        dataBase.delete(items)
        select()
        itemsTableViewEndEditing()
        removeSettingsContainer()
        instantiateItemsSettingsView()
    }
}
