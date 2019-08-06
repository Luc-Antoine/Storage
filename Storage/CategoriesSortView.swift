//
//  CategoriesSort.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 02/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoriesSortView: UIView {
    
    weak var controller: CategoriesController?
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    
    @IBAction func removeView() {
        controller!.removeSettingsContainer()
        controller!.instantiateCategoriesSettingsView()
    }
    
    @IBAction func sortChoice() {
        if controller!.categories.count > 1 {
            switch sortSegmentedControl.selectedSegmentIndex {
            case 0:
                controller!.categoriesSort = .increasing
                break
            case 1:
                controller!.categoriesSort = .decreasing
                break
            case 2:
                controller!.categoriesSort = .favoritesFirst
                break
            case 3:
                controller!.categoriesSort = .favoritesLast
                break
            default:
                break
            }
        }
        controller!.sortCategories()
    }
    
    func viewDidAppear() {
        sortSegmentedControl.selectedSegmentIndex = controller!.categoriesSort.rawValue
    }
}
