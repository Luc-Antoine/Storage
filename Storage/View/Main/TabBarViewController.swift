//
//  TabBarViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 30/04/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    weak private var categoryViewController: CategoriesViewController?
    
    private let lastLocation = LastLocation()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        instantiateItems()
    }
    
    // MARK: - Instantiate Functions
    
    func instantiateItems() {
        let categoriesNavigationController = CategoriesNavigationController()
        categoriesNavigationController.tabBarItem = UITabBarItem(title: "Objet", image: UIImage(named: "Collection"), tag: 0)
        let mapNavigationController = MapNavigationController()
        mapNavigationController.tabBarItem = UITabBarItem(title: "Carte", image: UIImage(named: "Pins"), tag: 1)
        mapNavigationController.lastLocation = lastLocation
        viewControllers = [categoriesNavigationController, mapNavigationController]
    }
}
