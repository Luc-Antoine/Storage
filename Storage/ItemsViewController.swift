//
//  ItemsViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 18/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController {
    
    var controller: ItemsController?
    
    @IBOutlet weak var settingsContainer: UIView!
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var addOrDeleteButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        controller!.instantiateItemsTableViewController()
        controller!.instantiateItemsSettingsView()
        controller!.removeFilters()
        title = controller!.category!.name
    }
    
    // MARK: - IBActions
    
    @IBAction func addOrDeleteAction() {
        guard controller!.navBarItemFilter != nil else { return }
        switch controller!.navBarItemFilter! {
        case .add:
            controller!.instantiateAddView()
            break
        case .delete:
            controller!.removeItems(controller!.itemsSelected)
            break
        case .filter:
            controller!.kindItem = .nameFeatures
            controller!.itemsViewController!.navBarItemFilter(nil)
            controller!.itemsTableViewContoller!.tableView.reloadData()
            break
        }
    }
    
    // MARK: - Navigation Controller Function
    
    func navBarItemFilter(_ option: NavBarItemFilter?) {
        controller!.navBarItemFilter = option
        if option == nil {
            addOrDeleteButton.image = nil
            addOrDeleteButton.isEnabled = false
        } else {
            switch option! {
            case .add:
                addOrDeleteButton.isEnabled = true
                addOrDeleteButton.image = UIImage(named: "Add")
                break
            case .delete:
                addOrDeleteButton.isEnabled = true
                addOrDeleteButton.image = UIImage(named: "Basket")
                break
            case .filter:
                addOrDeleteButton.isEnabled = true
                addOrDeleteButton.image = UIImage(named: "Add")
                break
            }
        }
    }
}
