//
//  UISegmentedControl.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 11/10/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    func font() {
        self.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Charter-Roman", size: 13)!], for: .normal)
    }
    
    func rounded() {
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    
    func searching(_ segment: Int) {
        let searchView: UIView = self.subviews[segment] as UIView
        searchView.backgroundColor = UIColor.selected
        searchView.tintColor = UIColor.white
        self.layer.borderColor = UIColor.mainColor.cgColor
        self.layer.borderWidth = 1
    }
}
