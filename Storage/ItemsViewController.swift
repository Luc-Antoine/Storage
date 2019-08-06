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
    @IBOutlet weak var addButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        instantiate()
        title()
    }
    
    // MARK: - IBActions
    
    @IBAction func addItem() {
        controller?.itemsSettingsController.instantiateAddView()
    }
    
    // MARK: - Instantiate Functions
    
    private func instantiate() {
        controller!.instantiateItemsTableViewController()
        controller!.instantiateItemsSettingsController()
    }
    
    // MARK: - Design Functions
    
    private func title() {
        title = controller!.categorySelected!.name!
    }
}
