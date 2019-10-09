//
//  MapNavigationController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 06/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class MapNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.tintColor = UIColor.mainColor
        newAnnotationsViewController()
        title = "carte"
    }
    
    func newAnnotationsViewController() {
        let annotationsViewController: AnnotationsViewController = instantiate("AnnotationsViewController", storyboard: "Annotations")
        pushViewController(annotationsViewController, animated: true)
    }
}
