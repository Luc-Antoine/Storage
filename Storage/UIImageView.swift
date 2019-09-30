//
//  UIImage.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 18/09/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func borderDesign() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor(red: 7/255, green: 90/255, blue: 172/255, alpha: 1).cgColor
    }
}
