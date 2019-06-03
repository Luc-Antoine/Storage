//
//  NavigationController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 02/05/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

enum FirstViewController {
    case CategoryViewController, ListAnnotationTableViewController
}

class NavigationController: UINavigationController {
    
    weak private var categoryViewController: CategoryViewController?
    var firstViewController: FirstViewController?
    private let styleCSS = StyleCSS()

    override func viewDidLoad() {
        super.viewDidLoad()

        globalDesign()
        instantiateViewControllers()
    }
    
    func instantiateViewControllers() {
        guard firstViewController != nil else { return }
        switch firstViewController! {
        case .CategoryViewController:
            let categoryController = CategoryController()
            categoryController.instantiateCategoryViewController(navigationController: self)
            //instantiateCategoryViewController()
            break
        case .ListAnnotationTableViewController:
            instantiateListAnnotationTableViewController()
            break
        }
    }
    
    func instantiateCategoryViewController() {
        let storyboard = UIStoryboard(name: "Category", bundle: nil)
        categoryViewController = (storyboard.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController)
        self.addChild(categoryViewController!)
        categoryViewController!.view.frame.size = self.view.frame.size
        self.navigationController?.pushViewController(categoryViewController!, animated: true)
    }
    
    func instantiateListAnnotationTableViewController() {
        print("ListAnnotationTableViewController")
    }
    
    // MARK: - Design Functions
    
    private func globalDesign() {
        styleCSS.tabBarColor()
        styleCSS.navigationBarColor()
    }
}
