//
//  UIViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 16/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - Design
    
    func navigationBarDesign() {
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func navigationBack() {
        backButton()
        backTitle()
    }
    
    func backButton() {
        let yourBackImage = UIImage(named: "Back")
        navigationController?.navigationBar.backIndicatorImage = yourBackImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
    }
    
    func backTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func title(_ text: String) {
        self.title = text
        let frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        let tlabel = UILabel(frame: frame)
        tlabel.text = self.title
        tlabel.numberOfLines = 0
        tlabel.textColor = UIColor.nightBlue
        tlabel.font = UIFont(name: "Futura-Bold", size: 18)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.textAlignment = .center
        self.navigationItem.titleView = tlabel
    }
    
    // MARK: - Navigation
    
    func instantiate<T>(_ identifier: String, storyboard: String, bundle: Bundle? = nil) -> T {
        let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        return viewController as! T
    }
    
    func remove() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func addChild(_ child: UIViewController, container: UIView) {
        addChild(child)
        container.addSubview(child.view)
        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        child.view.frame = container.bounds
        child.didMove(toParent: self)
    }
}
