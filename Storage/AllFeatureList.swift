//
//  AllFeatureList.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 16/09/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

class AllFeatureList {
    
    private let dataBase = DataBase()
    
    func all(_ nameFeaturesId: Int) -> [Feature] {
        let features = dataBase.select(nameFeaturesId: nameFeaturesId).sorted(by: {
            $0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending
        })
        return features.removeDuplicates()
    }
    
    func insert(_ item: Item, _ nameFeature: NameFeature, _ feature: Feature) {
        dataBase.insert(item, nameFeature: nameFeature, feature: feature)
    }
    
    func increase(_ feature: Feature) {
        dataBase.increase(feature)
    }
    
    func decrease(_ feature: Feature) {
        dataBase.decrease(feature)
    }
    
    func delete(_ item: Item, _ nameFeature: NameFeature, _ feature: Feature) {
        dataBase.delete(item, nameFeature: nameFeature, feature: feature)
        dataBase.delete(feature)
    }
}
