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
}
