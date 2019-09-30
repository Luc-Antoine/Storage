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
        firstViewController.tabBarItem = UITabBarItem(title: "Objet", image: UIImage(named: "RussianDolls"), tag: 0)
//        let secondController = instantiateCalculatorViewController()
//        secondController.tabBarItem = UITabBarItem(title: "Calc", image: UIImage(named: "Calculator"), tag: 1)
        let secondController = MapNavigationController()
        secondController.tabBarItem = UITabBarItem(title: "Carte", image: UIImage(named: "Mappin"), tag: 1)
        
        viewControllers = [firstViewController, secondController]
    }
    
    func instantiateCalculatorViewController() -> CalculatorViewController {
        let storyboard = UIStoryboard(name: "Calculator", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "CalculatorViewController") as! CalculatorViewController
    }
    
    func instantiateListAnnotationTableViewController() -> ListAnnotationTableViewController {
        let storyboard = UIStoryboard(name: "Map", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ListAnnotationTableViewController") as! ListAnnotationTableViewController
    }
}
