//
//  UITextField.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 05/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

extension UITextField {
    
    func borderDesign() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor(red: 49/255, green: 140/255, blue: 231/255, alpha: 1).cgColor
    }
    
    func border() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor(red: 7/255, green: 90/255, blue: 172/255, alpha: 1).cgColor
    }
    
    func paddingLeft() {
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
