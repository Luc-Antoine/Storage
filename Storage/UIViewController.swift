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
    
    func instantiate<T>(_ identifier: String, container: UIView, storyboard: String, bundle: Bundle? = nil) -> T {
        let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        addChild(viewController, container: container)
        return viewController as! T
    }
    
    func instantiate<T>(_ identifier: String, navigationController: UINavigationController, storyboard: String? = nil, bundle: Bundle? = nil) -> T {
        let storyboard = UIStoryboard(name: storyboard ?? identifier, bundle: bundle)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        navigationController.pushViewController(viewController, animated: true)
        return viewController as! T
    }
    
    func remove() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    private func addChild(_ child: UIViewController, container: UIView) {
        addChild(child)
        container.addSubview(child.view)
        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        child.view.frame = container.bounds
        child.didMove(toParent: self)
    }
}
