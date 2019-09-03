//
//  UIViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 16/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - Navigation Back Button
    
    func backButton() {
        let yourBackImage = UIImage(named: "CancelButton")
        navigationController?.navigationBar.backIndicatorImage = yourBackImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
    }
    
    func backTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func instantiate<T>(_ identifier: String) -> T {
        return storyboard?.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
