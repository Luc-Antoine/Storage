//
//  CategoryNavigationController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 03/05/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoryNavigationController: UINavigationController {
    
    weak private var categoryViewController: CategoryViewController?
    private let styleCSS = StyleCSS()

    override func viewDidLoad() {
        super.viewDidLoad()

        styleCSS.tabBarColor()
        styleCSS.navigationBarColor()
        instantaiteCategoryController()
    }
    
    func instantiateCategoryViewController() {
        let storyboard = UIStoryboard(name: "Category", bundle: nil)
        categoryViewController = (storyboard.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController)
        self.addChild(categoryViewController!)
        categoryViewController!.view.frame.size = self.view.frame.size
        self.navigationController?.pushViewController(categoryViewController!, animated: true)
    }
    
    func instantaiteCategoryController() {
        let categoryController = CategoryController()
        categoryController.instantiateCategoryViewController(navigationController: self)
    }
}
