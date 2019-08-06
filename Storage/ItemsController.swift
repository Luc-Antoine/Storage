//
//  ItemsController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 06/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class ItemsController: UIController {
    
    enum DataAsked {
        case items, filtereditems, researchingitems, titlefeatures, features, filtersediting
    }
    
    var dataAsked: DataAsked = .items
    var items: [Item] = []
    var itemsSelected: [Item] = []
    var filteredItem: [Item] = []
    var researchingItem: [Item] = []
    var titleFeatures: [String] = []
    var allFeatures: [String:[String]] = [:]
    var titleFeatureSelected: String = ""
    var filters: [String] = []
    
    var listItem: [String] = []
    var features: [String] = []
    var categorySelected: Category?
    var itemSort: ArrayDisplay.Sort = .increasing
    var modified: Bool = false
    var searchActive: Bool = false
    var viewHeight: CGFloat = 0
    var settingSegmentedIndex: Int = 3
    var featuresIndex: Int = 0
    
    var filtersSelected: [String] = []
    
    let itemsSettingsController = ItemsSettingsController()
    weak var itemsViewController: ItemsViewController?
    weak var itemsTableViewContoller: ItemsTableViewController?
    
    // MARK: - Instantiate Functions
    
    func instantiateItemsViewContainer(categoriesViewContainer: CategoriesViewController) {
        itemsViewController = instantiate("ItemsViewController", storyboard: "Items", bundle: nil)
        push(categoriesViewContainer.navigationController!, viewController: itemsViewController!)
        itemsViewController!.controller = self
    }
    
    func instantiateItemsTableViewController() {
        itemsTableViewContoller = instantiate("ItemsTableViewController", storyboard: "Items", bundle: nil)
        child(itemsViewController!, child: itemsTableViewContoller!, container: itemsViewController!.tableViewContainer)
        
        itemsTableViewContoller!.controller = self
    }
    
    func instantiateItemsSettingsController() {
        itemsSettingsController.instantiateItemsSettingsView(itemsViewController!, itemsController: self)
    }
    
    func removeSettingsContainer() {
        itemsViewController?.settingsContainer.subviews.first?.removeFromSuperview()
    }
    
    // MARK: - Sort Function
    
    func sortItem() {
        if filteredItem.count > 0 {
            switch itemSort {
            case .increasing:
                filteredItem = filteredItem.sorted(by: { $0.name!.lowercased() < $1.name!.lowercased() })
                break
            case .decreasing:
                filteredItem = filteredItem.sorted(by: { $0.name!.lowercased() > $1.name!.lowercased() })
                break
            case .favoritesFirst:
                filteredItem = filteredItem.sorted(by: { $0.favorites && !$1.favorites })
                break
            case .favoritesLast:
                filteredItem = filteredItem.sorted(by: { !$0.favorites && $1.favorites })
                break
            }
        } else {
            switch itemSort {
            case .increasing:
                items = items.sorted(by: { $0.name!.lowercased() < $1.name!.lowercased() })
                break
            case .decreasing:
                items = items.sorted(by: { $0.name!.lowercased() > $1.name!.lowercased() })
                break
            case .favoritesFirst:
                items = items.sorted(by: { $0.favorites && !$1.favorites })
                break
            case .favoritesLast:
                items = items.sorted(by: { !$0.favorites && $1.favorites })
                break
            }
        }
        itemsTableViewContoller?.tableView.reloadData()
    }
}
