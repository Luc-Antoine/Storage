//
//  CategoriesNavigationController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 03/05/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoriesNavigationController: UINavigationController {
    
    private let styleCSS = StyleCSS()

    override func viewDidLoad() {
        super.viewDidLoad()

        styleCSS.tabBarColor()
        styleCSS.navigationBarColor()
        instantiateCategoriesController()
    }
    
    func instantiateCategoriesController() {
        let categoriesController = CategoriesController()
        categoriesController.instantiateCategoriesViewController(navigationController: self)
    }
}
