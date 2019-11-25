//
//  UIView.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 28/09/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

extension UIView {
    
    func borderFocus() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor.rgb(7, 90, 172).cgColor
    }
    
    func borderActive() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor.rgb(143, 181, 217).cgColor
    }
    
    func borderInactive() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor.rgb(201, 203, 205).cgColor
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
//        self.layer.borderWidth = 1
//        self.layer.borderColor = UIColor.rgb(7, 90, 172).cgColor
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
