//
//  CategoriesNavigationController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 03/05/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoriesNavigationController: UINavigationController {
    
    weak private var categoriesViewController: CategoriesViewController?
    private let styleCSS = StyleCSS()

    override func viewDidLoad() {
        super.viewDidLoad()

        styleCSS.tabBarColor()
        styleCSS.navigationBarColor()
        instantaiteCategoriesController()
    }
    
    func instantiateCategoriesViewController() {
        let storyboard = UIStoryboard(name: "Categories", bundle: nil)
        categoriesViewController = (storyboard.instantiateViewController(withIdentifier: "CategoriesViewController") as! CategoriesViewController)
        self.addChild(categoriesViewController!)
        categoriesViewController!.view.frame.size = self.view.frame.size
        self.navigationController?.pushViewController(categoriesViewController!, animated: true)
    }
    
    func instantaiteCategoriesController() {
        let categoriesController = CategoriesController()
        categoriesController.instantiateCategoriesViewController(navigationController: self)
    }
}
