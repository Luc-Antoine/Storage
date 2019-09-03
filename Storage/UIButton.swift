//
//  UIButton.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 16/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

extension UIButton {
    func border() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 7/255, green: 90/255, blue: 172/255, alpha: 1).cgColor
        self.layer.cornerRadius = 5
    }
}
