//
//  InitDataBase.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 18/09/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import Foundation

class CreateDataBase {
    private let dataBase = DataBase()
    private let preferences = Preferences()
    
    func execute() {
        dataBase.createCategoryTable()
        dataBase.createItemTable()
        dataBase.createAnnotationTable()
        dataBase.createNameFeaturesTable()
        dataBase.createFeaturesTable()
        dataBase.createItemFeatureTable()
    }
    
    func preferencesDefault() {
        preferences.categorySort(0)
        preferences.itemSort(0)
        preferences.annotationSort(0)
    }
    
    func demo() {
        let demonstration = Demonstration()
        let language = Locale.current.languageCode
        if language == "fr" {
            demonstration.french()
        } else {
            demonstration.english()
        }
    }
}
