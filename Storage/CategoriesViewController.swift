//
//  CategoriesViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 01/05/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    var controller: CategoriesController?
    
    var categories: [Category] = []
    var tableViewIsEditing: Bool = false
    
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var settingsContainer: UIView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    private let styleCSS = StyleCSS()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller!.instantiateCategoriesSettingsView()
        controller!.instantiateCategoriesTableViewController(categoriesViewController: self, container: tableViewContainer)
    }
    
    // MARK: - IBActions
    
    @IBAction func addOrDeleteAction() {
        if tableViewIsEditing {
            controller?.removeCategory(categories: controller!.selectedCategories)
        } else {
            controller?.instantiateCategoriesAddView()
        }
    }
    
    // MARK: - Table View Functions
    
    func tableViewEditing() {
        tableViewIsEditing = true
        addButton.image = UIImage(named: "Basket")
    }
    
    func tableViewEndEditing() {
        tableViewIsEditing = false
        addButton.image = UIImage(named: "Add")
    }
    
    // MARK: - Design Functions
    
    private func globalDesign() {
        styleCSS.tabBarColor()
        styleCSS.navigationBarColor()
    }
    
    private func design() {
//        containerView.isHidden = true
//        editView.isHidden = true
//        searchView.isHidden = true
//        sortView.isHidden = true
//        addView.isHidden = true
//        styleCSS.borderTextField(textFields: [searchBar, addBar, editBar])
    }
    
    private func firstTime() {
        controller!.firstTime()
    }

}
