//
//  FeatureList.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 13/09/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

class FeatureList {
    private let dataBase = DataBase()
    
    func all(_ id: Int) -> [Feature] {
        return dataBase.select(id)
    }
    
    func all(_ id: Int) -> [NameFeature] {
        return dataBase.select(id)
    }
    
    func selectCount(_ id: Int) -> Int {
        return dataBase.selectCount(id)
    }
    
    func lastFeatureId() -> Int {
        return dataBase.lastFeatureId()
    }
    
    func add(_ feature: Feature, _ nameFeature: NameFeature, _ item: Item) {
        dataBase.insert(feature)
        dataBase.insert(nameFeature, item: item)
    }
    
    func add(_ nameFeature: NameFeature) {
        dataBase.insert(nameFeature)
    }
    
    func update(_ nameFeature: NameFeature) {
        dataBase.update(nameFeature)
    }
    
    func update(_ feature: Feature, _ index: Int, _ item: Item, _ nameFeature: NameFeature) {
        let featureAlreadySaved: Feature? = dataBase.check(feature)
        if featureAlreadySaved != nil {
            dataBase.increase(featureAlreadySaved!)
            dataBase.insert(item.id, nameFeatureId: nameFeature.id, featureId: featureAlreadySaved!.id)
        } else {
            dataBase.insert(feature)
            dataBase.insert(item.id, nameFeatureId: nameFeature.id, featureId: feature.id)
        }
    }
    
    func oldFeature(_ item: Item, _ nameFeature: NameFeature, _ oldFeature: Feature) {
        dataBase.delete(item, nameFeature: nameFeature, feature: oldFeature)
        if oldFeature.count > 1 {
            dataBase.decrease(oldFeature)
        } else {
            dataBase.delete(oldFeature)
        }
    }
    
    func remove(_ nameFeatures: [NameFeature]) {
        dataBase.delete(nameFeatures)
    }
}
