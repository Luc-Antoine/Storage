//
//  ItemsSortView.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 22/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class ItemsSortView: UIView {
    
    var controller: ItemsController?
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    
    @IBAction func removeView() {
        controller?.removeSettingsContainer()
        controller?.instantiateItemsSettingsView()
    }
    
    @IBAction func sortChoice() {
        switch sortSegmentedControl.selectedSegmentIndex {
        case 0:
            controller!.itemSort = .increasing
            break
        case 1:
            controller!.itemSort = .decreasing
            break
        case 2:
            controller!.itemSort = .favoritesFirst
            break
        case 3:
            controller!.itemSort = .favoritesLast
            break
        default:
            break
        }
        controller!.sortItem()
    }
    
    func viewDidAppear() {
        sortSegmentedControl.selectedSegmentIndex = controller!.itemSort.rawValue
    }
}
