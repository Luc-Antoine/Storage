//
//  UIController.swift
//  GoodFood
//
//  Created by Luc-Antoine Dupont on 25/07/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class UIController {
    
    func instantiate<T>(_ identifier: String, storyboard name: String, bundle: Bundle?) -> T {
        let storyboard = UIStoryboard(name: name, bundle: bundle)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as! T
        return viewController
    }
    
    func instantiate<T>(_ nibname: String, owner: Any?, options: [UINib.OptionsKey : Any]?) -> T {
        let views = Bundle.main.loadNibNamed(nibname, owner: nil, options: nil)
        return views?.first as! T
    }
    
    func child(_ parent: UIViewController, child: UIViewController, container: UIView) {
        parent.addChild(child)
        child.view.frame.size = container.frame.size
        container.addSubview(child.view)
    }
    
    func child(_ child: UIView, container: UIView) {
        child.frame.size = container.frame.size
        container.addSubview(child)
    }
    
    func push(_ navigationController: UINavigationController, viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
}
