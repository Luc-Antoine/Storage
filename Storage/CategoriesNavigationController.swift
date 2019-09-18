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

        navigationBar.tintColor = tintColor()
        newCategoriesViewController()
    }
    
    func newCategoriesViewController() {
        let categoriesViewController: CategoriesViewController = instantiate("CategoriesViewController", storyboard: "Categories")
        pushViewController(categoriesViewController, animated: true)
    }
}
