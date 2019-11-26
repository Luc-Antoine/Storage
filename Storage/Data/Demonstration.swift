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
    
    func french() {
        dataBase.insert(Category(id: 1, name: "Livres", favorite: true))
        dataBase.insert(Category(id: 2, name: "Billets", favorite: false))
        
        dataBase.insert(Item(id: 1, name: "Ne t'enfuis plus", categoryId: 1, favorite: true))
        dataBase.insert(Item(id: 2, name: "Orléans", categoryId: 1, favorite: false))
        dataBase.insert(Item(id: 3, name: "Horemheb, le retour de la lumière", categoryId: 1, favorite: false))
        
        dataBase.insert(NameFeature(id: 1, name: "Auteur", categoryId: 1))
        dataBase.insert(NameFeature(id: 2, name: "Genre", categoryId: 1))
        dataBase.insert(NameFeature(id: 3, name: "Parution", categoryId: 1))
        
        dataBase.insert(Feature(id: 1, name: "Harlan Coben", count: 1, itemId: 1, nameFeatureId: 1, featureId: 1))
        dataBase.insert(Feature(id: 2, name: "Policier", count: 1, itemId: 1, nameFeatureId: 2, featureId: 2))
        dataBase.insert(Feature(id: 3, name: "2019", count: 3, itemId: 1, nameFeatureId: 3, featureId: 3))
        
        dataBase.insert(Feature(id: 4, name: "Yann Moix", count: 1, itemId: 2, nameFeatureId: 1, featureId: 4))
        dataBase.insert(Feature(id: 5, name: "Roman", count: 1, itemId: 2, nameFeatureId: 2, featureId: 5))
        
        dataBase.insert(Feature(id: 6, name: "Chrisitan Jacq", count: 1, itemId: 3, nameFeatureId: 1, featureId: 6))
        dataBase.insert(Feature(id: 7, name: "Historique", count: 1, itemId: 3, nameFeatureId: 2, featureId: 7))
        
        dataBase.insert(1, nameFeatureId: 1, featureId: 1)
        dataBase.insert(1, nameFeatureId: 2, featureId: 2)
        dataBase.insert(1, nameFeatureId: 3, featureId: 3)
        dataBase.insert(2, nameFeatureId: 1, featureId: 4)
        dataBase.insert(2, nameFeatureId: 2, featureId: 5)
        dataBase.insert(2, nameFeatureId: 3, featureId: 3)
        dataBase.insert(3, nameFeatureId: 1, featureId: 6)
        dataBase.insert(3, nameFeatureId: 2, featureId: 7)
        dataBase.insert(3, nameFeatureId: 3, featureId: 3)
        
        
        
        dataBase.insert(Item(id: 4, name: "5000 Pesetas", categoryId: 2, favorite: true))
        dataBase.insert(Item(id: 5, name: "25 Francs", categoryId: 2, favorite: false))
        dataBase.insert(Item(id: 6, name: "50 Heller", categoryId: 2, favorite: false))
        
        dataBase.insert(NameFeature(id: 4, name: "Pays", categoryId: 2))
        dataBase.insert(NameFeature(id: 5, name: "Institut", categoryId: 2))
        dataBase.insert(NameFeature(id: 6, name: "Année", categoryId: 2))
        
        dataBase.insert(Feature(id: 8, name: "Espagne", count: 1, itemId: 4, nameFeatureId: 4, featureId: 8))
        dataBase.insert(Feature(id: 9, name: "Banco de Espana", count: 1, itemId: 4, nameFeatureId: 5, featureId: 9))
        dataBase.insert(Feature(id: 10, name: "1979", count: 1, itemId: 4, nameFeatureId: 6, featureId: 10))
        
        dataBase.insert(Feature(id: 11, name: "Martinique", count: 1, itemId: 5, nameFeatureId: 4, featureId: 11))
        dataBase.insert(Feature(id: 12, name: "Banque de la Martinique", count: 1, itemId: 5, nameFeatureId: 5, featureId: 12))
        dataBase.insert(Feature(id: 13, name: "1943", count: 1, itemId: 5, nameFeatureId: 6, featureId: 13))
        
        dataBase.insert(Feature(id: 14, name: "Autriche", count: 1, itemId: 6, nameFeatureId: 4, featureId: 14))
        dataBase.insert(Feature(id: 15, name: "Oberosterreich", count: 1, itemId: 6, nameFeatureId: 5, featureId: 15))
        dataBase.insert(Feature(id: 16, name: "1921", count: 1, itemId: 6, nameFeatureId: 6, featureId: 16))
        
        dataBase.insert(4, nameFeatureId: 4, featureId: 8)
        dataBase.insert(4, nameFeatureId: 5, featureId: 9)
        dataBase.insert(4, nameFeatureId: 6, featureId: 10)
        dataBase.insert(5, nameFeatureId: 4, featureId: 11)
        dataBase.insert(5, nameFeatureId: 5, featureId: 12)
        dataBase.insert(5, nameFeatureId: 6, featureId: 13)
        dataBase.insert(6, nameFeatureId: 4, featureId: 14)
        dataBase.insert(6, nameFeatureId: 5, featureId: 15)
        dataBase.insert(6, nameFeatureId: 6, featureId: 16)
        
        dataBase.insert(Annotation(id: 1, title: "Arc de Triomphe", subtitle: "contruit en 1836", comment: "", lat: 48.8738, lng: 2.29504, favorite: false, categories: ""))
        dataBase.insert(Annotation(id: 2, title: "Tour Eiffel", subtitle: "contruit en 1887", comment: "", lat: 48.8583, lng: 2.2945, favorite: false, categories: ""))
        dataBase.insert(Annotation(id: 3, title: "Louvre", subtitle: "contruit en 1776", comment: "", lat: 48.8611968051426, lng: 2.33510438781378, favorite: true, categories: ""))
        dataBase.insert(Annotation(id: 4, title: "Château de Chantilly", subtitle: "contruit en 1882", comment: "", lat: 49.1939, lng: 2.48541, favorite: true, categories: ""))
    }
    
    func english() {
        dataBase.insert(Category(id: 1, name: "Books", favorite: true))
        dataBase.insert(Category(id: 2, name: "Bank notes", favorite: false))
        
        dataBase.insert(Item(id: 1, name: "Run Away", categoryId: 1, favorite: true))
        dataBase.insert(Item(id: 2, name: "Orléans", categoryId: 1, favorite: false))
        dataBase.insert(Item(id: 3, name: "Horemheb, le retour de la lumière", categoryId: 1, favorite: false))
        
        dataBase.insert(NameFeature(id: 1, name: "Author", categoryId: 1))
        dataBase.insert(NameFeature(id: 2, name: "Kind", categoryId: 1))
        dataBase.insert(NameFeature(id: 3, name: "Publication", categoryId: 1))
        
        dataBase.insert(Feature(id: 1, name: "Harlan Coben", count: 1, itemId: 1, nameFeatureId: 1, featureId: 1))
        dataBase.insert(Feature(id: 2, name: "Thriller", count: 1, itemId: 1, nameFeatureId: 2, featureId: 2))
        dataBase.insert(Feature(id: 3, name: "2019", count: 3, itemId: 1, nameFeatureId: 3, featureId: 3))
        
        dataBase.insert(Feature(id: 4, name: "Yann Moix", count: 1, itemId: 2, nameFeatureId: 1, featureId: 4))
        dataBase.insert(Feature(id: 5, name: "Novel", count: 1, itemId: 2, nameFeatureId: 2, featureId: 5))
        
        dataBase.insert(Feature(id: 6, name: "Chrisitan Jacq", count: 1, itemId: 3, nameFeatureId: 1, featureId: 6))
        dataBase.insert(Feature(id: 7, name: "History", count: 1, itemId: 3, nameFeatureId: 2, featureId: 7))
        
        dataBase.insert(1, nameFeatureId: 1, featureId: 1)
        dataBase.insert(1, nameFeatureId: 2, featureId: 2)
        dataBase.insert(1, nameFeatureId: 3, featureId: 3)
        dataBase.insert(2, nameFeatureId: 1, featureId: 4)
        dataBase.insert(2, nameFeatureId: 2, featureId: 5)
        dataBase.insert(2, nameFeatureId: 3, featureId: 3)
        dataBase.insert(3, nameFeatureId: 1, featureId: 6)
        dataBase.insert(3, nameFeatureId: 2, featureId: 7)
        dataBase.insert(3, nameFeatureId: 3, featureId: 3)
        
        
        
        dataBase.insert(Item(id: 4, name: "5000 Pesetas", categoryId: 2, favorite: true))
        dataBase.insert(Item(id: 5, name: "25 Francs", categoryId: 2, favorite: false))
        dataBase.insert(Item(id: 6, name: "50 Heller", categoryId: 2, favorite: false))
        
        dataBase.insert(NameFeature(id: 4, name: "Country", categoryId: 2))
        dataBase.insert(NameFeature(id: 5, name: "Institution", categoryId: 2))
        dataBase.insert(NameFeature(id: 6, name: "Year", categoryId: 2))
        
        dataBase.insert(Feature(id: 8, name: "Spain", count: 1, itemId: 4, nameFeatureId: 4, featureId: 8))
        dataBase.insert(Feature(id: 9, name: "Banco de Espana", count: 1, itemId: 4, nameFeatureId: 5, featureId: 9))
        dataBase.insert(Feature(id: 10, name: "1979", count: 1, itemId: 4, nameFeatureId: 6, featureId: 10))
        
        dataBase.insert(Feature(id: 11, name: "Martinique", count: 1, itemId: 5, nameFeatureId: 4, featureId: 11))
        dataBase.insert(Feature(id: 12, name: "Banque de la Martinique", count: 1, itemId: 5, nameFeatureId: 5, featureId: 12))
        dataBase.insert(Feature(id: 13, name: "1943", count: 1, itemId: 5, nameFeatureId: 6, featureId: 13))
        
        dataBase.insert(Feature(id: 14, name: "Austria", count: 1, itemId: 6, nameFeatureId: 4, featureId: 14))
        dataBase.insert(Feature(id: 15, name: "Oberosterreich", count: 1, itemId: 6, nameFeatureId: 5, featureId: 15))
        dataBase.insert(Feature(id: 16, name: "1921", count: 1, itemId: 6, nameFeatureId: 6, featureId: 16))
        
        dataBase.insert(4, nameFeatureId: 4, featureId: 8)
        dataBase.insert(4, nameFeatureId: 5, featureId: 9)
        dataBase.insert(4, nameFeatureId: 6, featureId: 10)
        dataBase.insert(5, nameFeatureId: 4, featureId: 11)
        dataBase.insert(5, nameFeatureId: 5, featureId: 12)
        dataBase.insert(5, nameFeatureId: 6, featureId: 13)
        dataBase.insert(6, nameFeatureId: 4, featureId: 14)
        dataBase.insert(6, nameFeatureId: 5, featureId: 15)
        dataBase.insert(6, nameFeatureId: 6, featureId: 16)
        
        dataBase.insert(Annotation(id: 1, title: "Statue of Liberty", subtitle: "built in 1886", comment: "", lat: 40.6892574131197, lng: -74.0446082550508, favorite: false, categories: ""))
        dataBase.insert(Annotation(id: 2, title: "Miami Seaquarium", subtitle: "built in 1955", comment: "", lat: 25.733276784853068, lng: -80.16524822451174, favorite: false, categories: ""))
        dataBase.insert(Annotation(id: 3, title: "Empire State Building", subtitle: "built in 1931", comment: "", lat: 40.748452, lng: -73.985595, favorite: true, categories: ""))
        dataBase.insert(Annotation(id: 4, title: "Big Cypress National Preserve", subtitle: "established by law in 1974", comment: "", lat: 25.768103112056725, lng: -80.8337389677761, favorite: true, categories: ""))
    }
}
