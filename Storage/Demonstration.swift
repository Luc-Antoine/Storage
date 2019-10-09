//
//  Demonstration.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 29/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

class Demonstration {
    private let dataBase = DataBase()
    
    func run() {
        dataBase.insert(Category(id: 1, name: "Chats", favorite: true))
        
        dataBase.insert(Item(id: 1, name: "Momo", categoryId: 1, favorite: true))
        dataBase.insert(Item(id: 2, name: "Cacou", categoryId: 1, favorite: false))
        dataBase.insert(Item(id: 3, name: "Boubouille", categoryId: 1, favorite: false))
        
        dataBase.insert(NameFeature(id: 1, name: "Âge", categoryId: 1))
        dataBase.insert(NameFeature(id: 2, name: "Couleurs", categoryId: 1))
    }
    
    func test() {
        dataBase.insert(Item(id: 4, name: "Angora", categoryId: 1, favorite: false))
    }
}
