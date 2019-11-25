//
//  SortViewModel.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 20/11/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

struct SortViewModel {
    
    weak var delegate: SortViewDelegate?
    
    private let preferences = Preferences()
    
    func sortIndex(_ data: String) -> Int {
        switch data {
        case "categories":
            return preferences.categorySort()
        case "items":
            return preferences.itemSort()
        case "annotations":
            return preferences.annotationSort()
        default:
            return 0
        }
    }
    
    func sortIndex(_ data: String, _ index: Int) {
        newOrder(Sort(rawValue: index)!)
        switch data {
        case "categories":
            preferences.categorySort(index)
            break
        case "items":
            preferences.itemSort(index)
            break
        case "annotations":
            preferences.annotationSort(index)
            break
        default:
            break
        }
    }
    
    func newChildSettings() {
        delegate?.newChildSettings()
    }
    
    func newOrder(_ sort: Sort) {
        delegate?.newSort(sort)
    }
}
