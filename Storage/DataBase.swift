//
//  DataBase.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 02/02/2017.
//  Copyright © 2017 Luc-Antoine Dupont. All rights reserved.
//

import UIKit
import CoreData

class DataBase {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let preferences = Preferences()
    
    func newObject(forEntity: String) -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: forEntity, into: context)
    }
    
    func addCategory(categoryName: String) {
        //DispatchQueue.global(qos: .userInteractive).async {
            let newCategory = self.newObject(forEntity: "Category")
            let id_category: Int = self.preferences.getPreferences(key: "id_category")
            newCategory.setValue(categoryName, forKey: "name")
            newCategory.setValue(false, forKey: "favorites")
            newCategory.setValue("", forKey: "titleFeature")
            newCategory.setValue(id_category, forKey: "id")
            do {
                try self.context.save()
                self.preferences.savePreferences(value: id_category + 1, key: "id_category")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
    }
    
    func addItem(category: Category, itemName: String) {
        DispatchQueue.global(qos: .userInteractive).async {
            let newItem = self.newObject(forEntity: "Item")
            let id_item: Int = self.preferences.getPreferences(key: "id_item")
            let feature: String = ""
            newItem.setValue(itemName, forKey: "name")
            newItem.setValue(false, forKey: "favorites")
            newItem.setValue(feature, forKey: "features")
            newItem.setValue(category.id, forKey: "category_id")
            newItem.setValue(id_item, forKey: "id")
            do {
                try self.context.save()
                self.preferences.savePreferences(value: id_item + 1, key: "id_item")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    // MARK: - Update Functions
    
    func setCategory(category: Category, newName: String) {
        let categories = getCategories(predicateFormat: "id == \(category.id)")
        guard categories.count > 0 else { return }
        categories[0].setValue(newName.noSpaceToLast(), forKey: "name")
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func setItem(item: Item, newName: String) {
        getItem(predicateFormat: "id == \(item.id)", completion: { results in
            guard results.count > 0 else { return }
            results[0].setValue(newName, forKey: "name")
            do {
                try self.context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        })
    }
    
    func setFeature(category: Category, newName: String) {
        let categories = getCategories(predicateFormat: "id == \(category.id)")
        guard categories.count > 0 else { return }
        for category in categories {
            category.setValue(newName, forKey: "titleFeature")
        }
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Favorites Functions
    
    func setFavorites(category: Category, favorites: Bool) {
        let categories: [Category] = getCategories(predicateFormat: "id == \(category.id)")
        guard categories.count > 0 else { return }
        category.setValue(categories.first!.favorites, forKey: "favorites")
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func setFavorites(item: Item, favorites: Bool) {
        getItem(predicateFormat: "id == \(item.id)", completion: { result in
            item.setValue(!result.first!.favorites, forKey: "favorites")
            do {
                try self.context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        })
    }
    
    // MARK: - Titlefeature and feature Functions
    
    func setTitleFeature(category: Category, titleFeature: String) {
        let categories: [Category] = getCategories(predicateFormat: "id == \(category.id)")
        guard categories.count > 0 else { return }
        for category in categories {
            category.setValue(titleFeature, forKey: "titleFeature")
        }
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func setFeature(item: Item, feature: String) {
        getItem(predicateFormat: "id == \(item.id)", completion: { results in
            for result in results {
                result.setValue(feature, forKey: "features")
            }
            do {
                try self.context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        })
    }
    
    func setFeature(category: Category, feature: String) {
        getItem(predicateFormat: "category_id == \(category.id)", completion: { results in
            for result in results {
                result.setValue(feature, forKey: "features")
            }
            do {
                try self.context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        })
    }
    
    // MARK: - Delete Functions
    
    func delete(_ categories: [Category]) throws {
        do {
            for category in categories {
                self.context.delete(category)
                try self.context.save()
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteItem(items: [Item], completion: @escaping (_ success: Bool) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                for i in 0..<items.count {
                    self.context.delete(items[i])
                    try self.context.save()
                }
                completion(true)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            completion(false)
        }
    }
    
    // MARK: - Get Functions
    
    func getCategories() -> [Category] {
        var results: [Category] = []
        do {
            results = try context.fetch(Category.fetchRequest())
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return results
    }
    
    func getCategories(predicateFormat: String) -> [Category] {
        let predicate = NSPredicate(format: predicateFormat)
        let request = NSFetchRequest<Category>(entityName: "Category")
        request.predicate = predicate
        var results: [Category] = []
        do {
            results = try context.fetch(request)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return results
    }
    
    func getItem(predicateFormat: String, completion: @escaping ([Item]) -> ()) {
        let predicate = NSPredicate(format: predicateFormat)
        let request = NSFetchRequest<Item>(entityName: "Item")
        request.predicate = predicate
        var results: [Item] = []
        do {
            results = try self.context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        completion(results)
    }
}
