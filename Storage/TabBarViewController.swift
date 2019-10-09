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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        instantiateItems()
    }
    
    // MARK: - Instantiate Functions
    
    func instantiateItems() {
        let firstViewController = CategoriesNavigationController()
        firstViewController.tabBarItem = UITabBarItem(title: "Objet", image: UIImage(named: "Collection"), tag: 0)
        let secondController = MapNavigationController()
        secondController.tabBarItem = UITabBarItem(title: "Carte", image: UIImage(named: "Pins"), tag: 1)
        viewControllers = [firstViewController, secondController]
    }
}
