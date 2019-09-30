//
//  AnnotationList.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 30/09/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

class AnnotationList {
    private let dataBase = DataBase()
    
    func all() -> [Annotation] {
        return dataBase.select()
    }
    
    func add(_ newAnnotation: Annotation) -> [Annotation] {
        dataBase.insert(newAnnotation)
        return all()
    }
    
    func update(_ annotation: Annotation) {
        dataBase.update(annotation)
    }
    
    func updateFavorite(_ annotation: Annotation) {
        dataBase.updateFavorite(annotation)
    }
    
    func remove(_ annotations: [Annotation]) -> [Annotation] {
        guard annotations.count > 0 else { return [] }
        dataBase.delete(annotations)
        return all()
    }
}
