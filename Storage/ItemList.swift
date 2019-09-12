//
//  ItemList.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 09/09/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

class ItemList {
    private let dataBase = DataBase()
    
    func all(_ id: Int) -> [Item] {
        return dataBase.select(id)
    }
    
    func add(_ itemName: String, _ id: Int) -> [Item] {
        guard itemName != "" else { return [] }
        dataBase.insert(Item(id: 0, name: itemName, categoryId: id, favorite: false))
        return all(id)
    }
    
    func updateFavorite(_ item: Item) {
        dataBase.update(item)
    }
    
    func removeItems(_ items: [Item], _ id: Int) -> [Item] {
        guard items.count > 0 else { return [] }
        dataBase.delete(items)
        return all(id)
    }
    
    func all(_ id: Int) -> [NameFeature] {
        return dataBase.select(id)
    }
    
    func all(_ items: [Item]) -> [Feature] {
        return dataBase.select(itemsId: items.map({ String($0.id) }).joined(separator: ","))
    }
}
