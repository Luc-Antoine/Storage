//
//  DataBaseAnnotation.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 15/03/2017.
//  Copyright © 2017 Luc-Antoine Dupont. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

extension DataBase {

    func addAnnotation(lat: CLLocationDegrees, lng: CLLocationDegrees, title: String, subtitle: String, comment: String) -> Annotation {
        let newAnnotation = newObject(forEntity: "Annotation")
        let id_annotation: Int32 = preferences.getPreferences(key: "id_annotation")
        newAnnotation.setValue(lat, forKey: "lat")
        newAnnotation.setValue(lng, forKey: "lng")
        newAnnotation.setValue(title, forKey: "title")
        newAnnotation.setValue(subtitle, forKey: "subtitle")
        newAnnotation.setValue(comment, forKey: "comment")
        newAnnotation.setValue(false, forKey: "favorites")
        newAnnotation.setValue(id_annotation, forKey: "id")
        do {
            try context.save()
            preferences.savePreferences(value: id_annotation + 1, key: "id_annotation")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return newAnnotation as! Annotation
    }
    
    func setAnnotation(annotation: Annotation, title: String, subtitle: String, comment: String) {
        getAnnotation(predicateFormat: "id == \(annotation.id)", completion: { result in
            annotation.setValue(title, forKey: "title")
            annotation.setValue(subtitle, forKey: "subtitle")
            annotation.setValue(comment, forKey: "comment")
            do {
                try self.context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        })
    }
    
    func deleteAnnotation(annotations: [Annotation], completion: @escaping (_ success: Bool) -> ()) {
        do {
            for i in 0..<annotations.count {
                self.context.delete(annotations[i])
                try self.context.save()
            }
            completion(true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        completion(false)
    }
    
    func setFavorites(annotation: Annotation, favorites: Bool) {
        getAnnotation(predicateFormat: "id == \(annotation.id)", completion: { result in
            annotation.setValue(!result.first!.favorites, forKey: "favorites")
            do {
                try self.context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        })
    }
    
    func getAnnotation(completion: @escaping ([Annotation]) -> ()) {
        var results: [Annotation] = []
        do {
            results = try context.fetch(Annotation.fetchRequest())
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        completion(results)
    }
    
    func getAnnotation(predicateFormat: String, completion: @escaping ([Annotation]) -> ()) {
        let predicate = NSPredicate(format: predicateFormat)
        let request = NSFetchRequest<Annotation>(entityName: "Annotation")
        request.predicate = predicate
        var results: [Annotation] = []
        do {
            results = try self.context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        completion(results)
    }
}
