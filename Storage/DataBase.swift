//
//  DataBase.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 02/02/2017.
//  Copyright © 2017 Luc-Antoine Dupont. All rights reserved.
//

import UIKit
import GRDB
import CoreData

class DataBase {
    var dbQueue: DatabaseQueue?
    let inMemoryDBQueue = DatabaseQueue()
    
    init() {
        do {
            let fileManager = FileManager.default
            let dbPath = try fileManager
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("dataBasePrivate.sqlite")
                .path
            
//            if !fileManager.fileExists(atPath: dbPath) {
//                let dbResourcePath = Bundle.main.path(forResource: "dataBasePrivate", ofType: "sqlite")!
//                try fileManager.copyItem(atPath: dbResourcePath, toPath: dbPath)
//            }
            dbQueue = try DatabaseQueue(path: dbPath)
        } catch {
            NSLog(error.localizedDescription)
        }
    }
}





extension DataBase {
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    let preferences = Preferences()
    
//    func newObject(forEntity: String) -> NSManagedObject {
//        return NSEntityDescription.insertNewObject(forEntityName: forEntity, into: context)
//    }
    
    func addItem(category: Category, itemName: String) {
//        DispatchQueue.global(qos: .userInteractive).async {
//            let newItem = self.newObject(forEntity: "Item")
//            let id_item: Int = self.preferences.getPreferences(key: "id_item")
//            let feature: String = ""
//            newItem.setValue(itemName, forKey: "name")
//            newItem.setValue(false, forKey: "favorites")
//            newItem.setValue(feature, forKey: "features")
//            newItem.setValue(category.id, forKey: "category_id")
//            newItem.setValue(id_item, forKey: "id")
//            do {
//                try self.context.save()
//                self.preferences.savePreferences(value: id_item + 1, key: "id_item")
//            } catch let error as NSError {
//                print("Could not save. \(error), \(error.userInfo)")
//            }
//        }
    }
    
    // MARK: - Update Functions
    
    func setItem(item: Item, newName: String) {
//        getItem(predicateFormat: "id == \(item.id)", completion: { results in
//            guard results.count > 0 else { return }
//            results[0].setValue(newName, forKey: "name")
//            do {
//                try self.context.save()
//            } catch let error as NSError {
//                print("Could not save. \(error), \(error.userInfo)")
//            }
//        })
    }
    
    // MARK: - Favorites Functions
    
    func setFavorites(category: Category, favorites: Bool) {
//        let categories: [Category] = getCategories(predicateFormat: "id == \(category.id)")
//        guard categories.count > 0 else { return }
//        category.setValue(categories.first!.favorites, forKey: "favorites")
//        do {
//            try self.context.save()
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
    }
    
    func setFavorites(item: Item, favorites: Bool) {
//        getItem(predicateFormat: "id == \(item.id)", completion: { result in
//            item.setValue(!result.first!.favorites, forKey: "favorites")
//            do {
//                try self.context.save()
//            } catch let error as NSError {
//                print("Could not save. \(error), \(error.userInfo)")
//            }
//        })
    }
    
    // MARK: - Titlefeature and feature Functions
    
    func setTitleFeature(category: Category, titleFeature: String) {
//        let categories: [Category] = getCategories(predicateFormat: "id == \(category.id)")
//        guard categories.count > 0 else { return }
//        for category in categories {
//            category.setValue(titleFeature, forKey: "titleFeature")
//        }
//        do {
//            try self.context.save()
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
    }
    
    func setFeature(item: Item, feature: String) {
//        getItem(predicateFormat: "id == \(item.id)", completion: { results in
//            for result in results {
//                result.setValue(feature, forKey: "features")
//            }
//            do {
//                try self.context.save()
//            } catch let error as NSError {
//                print("Could not save. \(error), \(error.userInfo)")
//            }
//        })
    }
    
    func setFeature(category: Category, feature: String) {
//        getItem(predicateFormat: "category_id == \(category.id)", completion: { results in
//            for result in results {
//                result.setValue(feature, forKey: "features")
//            }
//            do {
//                try self.context.save()
//            } catch let error as NSError {
//                print("Could not save. \(error), \(error.userInfo)")
//            }
//        })
    }
    
    // MARK: - Delete Functions
    
    func deleteItem(items: [Item], completion: @escaping (_ success: Bool) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
//            do {
//                for i in 0..<items.count {
//                    self.context.delete(items[i])
//                    try self.context.save()
//                }
//                completion(true)
//            } catch let error as NSError {
//                print("Could not save. \(error), \(error.userInfo)")
//            }
            completion(false)
        }
    }
    
    // MARK: - Get Functions
    
    func getCategories(predicateFormat: String) -> [Category] {
//        let predicate = NSPredicate(format: predicateFormat)
//        let request = NSFetchRequest<Category>(entityName: "Category")
//        request.predicate = predicate
        let results: [Category] = []
//        do {
//            results = try context.fetch(request)
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
        return results
    }
    
    func getItem(predicateFormat: String, completion: @escaping ([Item]) -> ()) {
//        let predicate = NSPredicate(format: predicateFormat)
//        let request = NSFetchRequest<Item>(entityName: "Item")
//        request.predicate = predicate
        let results: [Item] = []
//        do {
//            results = try self.context.fetch(request)
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
        completion(results)
    }
}
