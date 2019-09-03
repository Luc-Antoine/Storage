//
//  AllFeaturesController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 15/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class AllFeaturesController: UIController {
    
    weak var allFeaturesViewController: AllFeaturesViewController?
    weak var allFeaturesTableViewController: AllFeaturesTableViewController?
    weak var featuresTableViewDelegate: FeaturesTableViewDelegate?
    
    var item: Item?
    var features: [Feature] = []
    var feature: Feature?
    var nameFeature: NameFeature?
    
    private let dataBase = DataBase()
    
    // MARK: - Instantiate Functions
    
    func select() {
        features = dataBase.select(nameFeaturesId: nameFeature!.id).sorted(by: {
            $0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending
        })
        features = features.removeDuplicates()
    }
    
    // MARK: - Navigate Function
    
    func close() {
        allFeaturesViewController!.close()
    }
    
    // MARK: - DataBase Functions
    
    func update(_ newFeature: Feature) {
        dataBase.increase(newFeature)
        dataBase.insert(item!, nameFeature: nameFeature!, feature: newFeature)
        // A vérifier !!!
        featuresTableViewDelegate?.reloadFeature(newFeature)
        guard feature != nil else { return }
        if feature!.count > 1 {
            dataBase.decrease(feature!)
        } else {
            dataBase.delete(item!, nameFeature: nameFeature!, feature: feature!)
            dataBase.delete(feature!)
        }
    }
}
