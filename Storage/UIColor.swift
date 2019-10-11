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
    
    static var mainColor: UIColor {
        return rgb(7,90,172)
    }
    
    static var selected: UIColor {
        return rgb(94, 148, 201)
    }
    
    static var active: UIColor {
        return rgb(143, 181, 217)
    }
    
    static var nightBlue: UIColor {
        return rgb(3, 55, 105)
    }
}
