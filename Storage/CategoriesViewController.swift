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
    
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var settingsContainer: UIView!
    @IBOutlet weak var addOrDeleteButton: UIBarButtonItem!
    
    private let styleCSS = StyleCSS()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller!.instantiateCategoriesSettingsView()
        controller!.instantiateCategoriesTableViewController(categoriesViewController: self, container: tableViewContainer)
    }
    
    // MARK: - IBActions
    
    @IBAction func addOrDeleteAction() {
        guard controller!.navBarItem != nil else { return }
        switch controller!.navBarItem! {
        case .add:
            controller!.instantiateCategoriesAddView()
        case .delete:
            controller!.removeCategory(categories: controller!.selectedCategories)
        }
    }
    
    // MARK: - Navigation Controller Function
    
    func navBarOption(_ option: NavBarItem?) {
        controller!.navBarItem = option
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
            }
        }
    }
    
    // MARK: - Design Functions
    
    private func globalDesign() {
        styleCSS.tabBarColor()
        styleCSS.navigationBarColor()
    }
    
    private func firstTime() {
        controller!.firstTime()
    }

}
