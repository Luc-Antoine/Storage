//
//  AnnotationCategoriesToAnnotationsViewControllerDelegate.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 28/11/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

protocol AnnotationCategoriesToAnnotationsViewControllerDelegate: AnyObject {
    func categoriesFiltered() -> [Int]
    func remove()
}
