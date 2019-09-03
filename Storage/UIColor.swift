//
//  UIColor.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 19/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat? = nil) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a ?? 255/255)
    }
    
    static var separator: UIColor {
        return rgb(218,231,243)
    }
}
