//
//  Appearance.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 11/10/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class Appearance {
    
    func main() {
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.mainColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.nightBlue, NSAttributedString.Key.font: UIFont(name: "Futura-Bold", size: 18)!]
    }
}
