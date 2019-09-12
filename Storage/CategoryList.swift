//
//  CategoryList.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 09/09/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

class CategoryList {
    private let dataBase = DataBase()
    
    func all() -> [Category] {
        return dataBase.select()
    }
    
    func add(_ newCategoryName: String) -> [Category] {
        guard newCategoryName != "" else { return [] }
        dataBase.insert(Category(id: 0, name: newCategoryName, favorite: false))
        return all()
    }
    
    func updateFavorite(_ category: Category) {
        dataBase.update(category)
    }
    
    func remove(_ categories: [Category]) -> [Category] {
        guard categories.count > 0 else { return [] }
        dataBase.delete(categories)
        return all()
    }
}
