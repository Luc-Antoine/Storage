//
//  StorageTests.swift
//  StorageTests
//
//  Created by Luc-Antoine Dupont on 25/01/2017.
//  Copyright © 2017 Luc-Antoine Dupont. All rights reserved.
//

import XCTest
@testable import Storage

class StorageTests: XCTestCase {
    
    func testDemonstrationCategoriesSaved() {
        let categoryList = CategoryList()
        var categories: [Storage.Category] = []
        let language = Locale.current.languageCode
        
        if language == "fr" {
            categories = [
                Category(id: 1, name: "Livres", favorite: true),
                Category(id: 2, name: "Billets", favorite: false)
            ]
        } else {
            categories = [
                Category(id: 1, name: "Books", favorite: true),
                Category(id: 2, name: "Bank notes", favorite: false)
            ]
        }
        let categoriesSaved: [Storage.Category] = categoryList.all()
        XCTAssertEqual(categoriesSaved, categories)
    }
    
    func testDemonstrationItemsSaved() {
        let itemList = ItemList()
        var items: [Item] = []
        let language = Locale.current.languageCode
        
        if language == "fr" {
            items = [
                Item(id: 1, name: "Ne t'enfuis plus", categoryId: 1, favorite: true),
                Item(id: 2, name: "Orléans", categoryId: 1, favorite: false),
                Item(id: 3, name: "Horemheb, le retour de la lumière", categoryId: 1, favorite: false),
                Item(id: 4, name: "5000 Pesetas", categoryId: 2, favorite: true),
                Item(id: 5, name: "25 Francs", categoryId: 2, favorite: false),
                Item(id: 6, name: "50 Heller", categoryId: 2, favorite: false)
            ]
        } else {
            items = [
                Item(id: 1, name: "Run Away", categoryId: 1, favorite: true),
                Item(id: 2, name: "Orléans", categoryId: 1, favorite: false),
                Item(id: 3, name: "Horemheb, le retour de la lumière", categoryId: 1, favorite: false),
                Item(id: 4, name: "5000 Pesetas", categoryId: 2, favorite: true),
                Item(id: 5, name: "25 Francs", categoryId: 2, favorite: false),
                Item(id: 6, name: "50 Heller", categoryId: 2, favorite: false)
            ]
        }
        let itemsSaved: [Item] = itemList.all(1) + itemList.all(2)
        XCTAssertEqual(itemsSaved, items)
    }
    
    func testDemonstrationNameFeatureSaved() {
        let featureList = FeatureList()
        var nameFeatures: [NameFeature] = []
        let language = Locale.current.languageCode
        
        if language == "fr" {
            nameFeatures = [
                NameFeature(id: 1, name: "Auteur", categoryId: 1),
                NameFeature(id: 2, name: "Genre", categoryId: 1),
                NameFeature(id: 3, name: "Parution", categoryId: 1),
                NameFeature(id: 4, name: "Pays", categoryId: 2),
                NameFeature(id: 5, name: "Institut", categoryId: 2),
                NameFeature(id: 6, name: "Année", categoryId: 2)
            ]
        } else {
            nameFeatures = [
                NameFeature(id: 1, name: "Author", categoryId: 1),
                NameFeature(id: 2, name: "Kind", categoryId: 1),
                NameFeature(id: 3, name: "Publication", categoryId: 1),
                NameFeature(id: 4, name: "Country", categoryId: 2),
                NameFeature(id: 5, name: "Institution", categoryId: 2),
                NameFeature(id: 6, name: "Year", categoryId: 2)
            ]
        }
        let nameGeaturesSaved: [NameFeature] = featureList.all(1) + featureList.all(2)
        XCTAssertEqual(nameGeaturesSaved, nameFeatures)
    }
    
    func testDemonstrationFeatureSaved() {
        let featureList = FeatureList()
        var features1: [Feature] = []
        var features2: [Feature] = []
        var features3: [Feature] = []
        var features4: [Feature] = []
        var features5: [Feature] = []
        var features6: [Feature] = []
        let language = Locale.current.languageCode
        
        if language == "fr" {
            features1 = [
                Feature(id: 1, name: "Harlan Coben", count: 1, itemId: 1, nameFeatureId: 1, featureId: 1),
                Feature(id: 2, name: "Policier", count: 1, itemId: 1, nameFeatureId: 2, featureId: 2),
                Feature(id: 3, name: "2019", count: 3, itemId: 1, nameFeatureId: 3, featureId: 3)
            ]
                
            features2 = [
                Feature(id: 4, name: "Yann Moix", count: 1, itemId: 2, nameFeatureId: 1, featureId: 4),
                Feature(id: 5, name: "Roman", count: 1, itemId: 2, nameFeatureId: 2, featureId: 5),
                Feature(id: 3, name: "2019", count: 3, itemId: 2, nameFeatureId: 3, featureId: 3)
            ]
                
            features3 = [
                Feature(id: 6, name: "Chrisitan Jacq", count: 1, itemId: 3, nameFeatureId: 1, featureId: 6),
                Feature(id: 7, name: "Historique", count: 1, itemId: 3, nameFeatureId: 2, featureId: 7),
                Feature(id: 3, name: "2019", count: 3, itemId: 3, nameFeatureId: 3, featureId: 3)
            ]
                
            features4 = [
                Feature(id: 8, name: "Espagne", count: 1, itemId: 4, nameFeatureId: 4, featureId: 8),
                Feature(id: 9, name: "Banco de Espana", count: 1, itemId: 4, nameFeatureId: 5, featureId: 9),
                Feature(id: 10, name: "1979", count: 1, itemId: 4, nameFeatureId: 6, featureId: 10)
            ]
                
            features5 = [
                Feature(id: 11, name: "Martinique", count: 1, itemId: 5, nameFeatureId: 4, featureId: 11),
                Feature(id: 12, name: "Banque de la Martinique", count: 1, itemId: 5, nameFeatureId: 5, featureId: 12),
                Feature(id: 13, name: "1943", count: 1, itemId: 5, nameFeatureId: 6, featureId: 13)
            ]
                
            features6 = [
                Feature(id: 14, name: "Autriche", count: 1, itemId: 6, nameFeatureId: 4, featureId: 14),
                Feature(id: 15, name: "Oberosterreich", count: 1, itemId: 6, nameFeatureId: 5, featureId: 15),
                Feature(id: 16, name: "1921", count: 1, itemId: 6, nameFeatureId: 6, featureId: 16)
            ]
        } else {
            features1 = [
                Feature(id: 1, name: "Harlan Coben", count: 1, itemId: 1, nameFeatureId: 1, featureId: 1),
                Feature(id: 2, name: "Thriller", count: 1, itemId: 1, nameFeatureId: 2, featureId: 2),
                Feature(id: 3, name: "2019", count: 3, itemId: 1, nameFeatureId: 3, featureId: 3)
            ]
            
            features2 = [
                Feature(id: 4, name: "Yann Moix", count: 1, itemId: 2, nameFeatureId: 1, featureId: 4),
                Feature(id: 5, name: "Novel", count: 1, itemId: 2, nameFeatureId: 2, featureId: 5),
                Feature(id: 3, name: "2019", count: 3, itemId: 2, nameFeatureId: 3, featureId: 3)
            ]
            
            features3 = [
                Feature(id: 6, name: "Chrisitan Jacq", count: 1, itemId: 3, nameFeatureId: 1, featureId: 6),
                Feature(id: 7, name: "History", count: 1, itemId: 3, nameFeatureId: 2, featureId: 7),
                Feature(id: 3, name: "2019", count: 3, itemId: 3, nameFeatureId: 3, featureId: 3)
            ]
                
            features4 = [
                Feature(id: 8, name: "Spain", count: 1, itemId: 4, nameFeatureId: 4, featureId: 8),
                Feature(id: 9, name: "Banco de Espana", count: 1, itemId: 4, nameFeatureId: 5, featureId: 9),
                Feature(id: 10, name: "1979", count: 1, itemId: 4, nameFeatureId: 6, featureId: 10)
            ]
                
            features5 = [
                Feature(id: 11, name: "Martinique", count: 1, itemId: 5, nameFeatureId: 4, featureId: 11),
                Feature(id: 12, name: "Banque de la Martinique", count: 1, itemId: 5, nameFeatureId: 5, featureId: 12),
                Feature(id: 13, name: "1943", count: 1, itemId: 5, nameFeatureId: 6, featureId: 13)
            ]
                
            features6 = [
                Feature(id: 14, name: "Austria", count: 1, itemId: 6, nameFeatureId: 4, featureId: 14),
                Feature(id: 15, name: "Oberosterreich", count: 1, itemId: 6, nameFeatureId: 5, featureId: 15),
                Feature(id: 16, name: "1921", count: 1, itemId: 6, nameFeatureId: 6, featureId: 16)
            ]
        }
        let featuresSaved1: [Feature] = featureList.all(1)
        let featuresSaved2: [Feature] = featureList.all(2)
        let featuresSaved3: [Feature] = featureList.all(3)
        let featuresSaved4: [Feature] = featureList.all(4)
        let featuresSaved5: [Feature] = featureList.all(5)
        let featuresSaved6: [Feature] = featureList.all(6)
        
        XCTAssertEqual(featuresSaved1, features1)
        XCTAssertEqual(featuresSaved2, features2)
        XCTAssertEqual(featuresSaved3, features3)
        XCTAssertEqual(featuresSaved4, features4)
        XCTAssertEqual(featuresSaved5, features5)
        XCTAssertEqual(featuresSaved6, features6)
    }
    
    func testDemonstrationAnnotationSaved() {
        let annotationList = AnnotationList()
        var annotations: [Annotation] = []
        let language = Locale.current.languageCode
        
        if language == "fr" {
            annotations = [
                Annotation(id: 1, title: "Arc de Triomphe", subtitle: "contruit en 1836", comment: "", lat: 48.8738, lng: 2.29504, favorite: false),
                Annotation(id: 2, title: "Tour Eiffel", subtitle: "contruit en 1887", comment: "", lat: 48.8583, lng: 2.2945, favorite: false),
                Annotation(id: 3, title: "Louvre", subtitle: "contruit en 1776", comment: "", lat: 48.8611968051426, lng: 2.33510438781378, favorite: true),
                Annotation(id: 4, title: "Château de Chantilly", subtitle: "contruit en 1882", comment: "", lat: 49.1939, lng: 2.48541, favorite: true)
            ]
        } else {
            annotations = [
                Annotation(id: 1, title: "Statue of Liberty", subtitle: "built in 1886", comment: "", lat: 40.6892574131197, lng: -74.0446082550508, favorite: false),
                Annotation(id: 2, title: "Miami Seaquarium", subtitle: "built in 1955", comment: "", lat: 25.733276784853068, lng: -80.16524822451174, favorite: false),
                Annotation(id: 3, title: "Empire State Building", subtitle: "built in 1931", comment: "", lat: 40.748452, lng: -73.985595, favorite: true),
                Annotation(id: 4, title: "Big Cypress National Preserve", subtitle: "established by law in 1974", comment: "", lat: 25.768103112056725, lng: -80.8337389677761, favorite: true)
            ]
        }
        let annotationsSaved: [Annotation] = annotationList.all()
        XCTAssertEqual(annotationsSaved, annotations)
    }
    
}
