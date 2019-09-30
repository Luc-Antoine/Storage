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
        
        navigationBar.tintColor = tintColor()
        newAnnotationsViewController()
    }
    
    func newAnnotationsViewController() {
        let annotationsViewController: ListAnnotationTableViewController = instantiate("ListAnnotationTableViewController", storyboard: "Map")
        pushViewController(annotationsViewController, animated: true)
    }
    
//    private let styleCSS = StyleCSS()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        styleCSS.tabBarColor()
//        styleCSS.navigationBarColor()
//        instantiateMapController()
//    }
//
////    func instantiateListAnnotationTableViewController() {
////        let storyboard = UIStoryboard(name: "Map", bundle: nil)
////        let listAnnotationTableViewController = storyboard.instantiateViewController(withIdentifier: "ListAnnotationTableViewController") as! ListAnnotationTableViewController
////        self.addChild(listAnnotationTableViewController)
////        listAnnotationTableViewController.view.frame.size = self.view.frame.size
////        self.navigationController?.pushViewController(listAnnotationTableViewController, animated: true)
////    }
//
//    func instantiateMapController() {
//        let mapController = MapController()
//        mapController.instantiateListAnnotationTableViewController(self)
//    }

}
