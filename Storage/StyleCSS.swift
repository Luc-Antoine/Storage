//
//  Style.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 10/09/2017.
//  Copyright © 2017 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class StyleCSS {

    public func radiusUIButton(buttons: [UIButton]) {
        for button in buttons {
            button.layer.cornerRadius = 15.0
        }
    }
    
    public func buttonLikeSegmentedControl(buttons: [UIButton]) {
        for button in buttons {
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor(red: 73/255, green: 129/255, blue: 253/255, alpha: 1.0).cgColor
            button.layer.cornerRadius = 5.0
        }
    }
    
    public func borderTextField(textFields: [UITextField]) {
        for textField in textFields {
            textField.layer.borderWidth = 1.0
            textField.layer.cornerRadius = 5.0
            textField.layer.borderColor = UIColor(red: 49/255, green: 140/255, blue: 231/255, alpha: 1).cgColor
        }
    }
    
    public func borderTextView(textView: UITextView) {
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5.0
        textView.layer.borderColor = UIColor(red: 49/255, green: 140/255, blue: 231/255, alpha: 1).cgColor
    }
    
    public func tabBarColor() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    }
    
    public func navigationBarColor() {
        UINavigationBar.appearance().barTintColor = UIColor(red: 49/255, green: 140/255, blue: 231/255, alpha: 1)
    }
}
