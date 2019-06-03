//
//  AnnotationModel.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 15/03/2017.
//  Copyright © 2017 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

enum AnnotationAction {
    case add, close, confirm, delete
}

typealias ItemOptions = [String]

struct Position {
    let lat: Double
    let lng: Double
    
    init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
}

protocol AddAnnotationDelegate: AnyObject {
    func addAnnotation(annotation: Annotation)
}

protocol RemoveAnnotationDelegate: AnyObject {
    func removeAnnotation(annotation: Annotation)
}

protocol FeaturesDelegate: AnyObject {
    func setFeature(thisFeature: String, thisIndex: Int)
}

protocol CellDelegate: AnyObject {
    func getRow(index: Int, title: String, textFieldText: String)
}

protocol CellTextFieldEditing: AnyObject {
    func cellTextFieldEditing()
}



protocol ButtonAnnotationDelegate: AnyObject {
    func actionButtonAnnotation(action: AnnotationAction)
}

protocol TitleAnnotationDelegate: AnyObject {
    func setTitleAnnotation(textField: UITextField)
    func getTitle(title: String)
}

protocol SubtitleAnnotationDelegate: AnyObject {
    func setSubtitleAnnotation(textField: UITextField)
    func getSubtitle(subtitle: String)
}

protocol CommentAnnotationDelegate: AnyObject {
    func setCommentAnnotation(textView: UITextView)
    func getComment(comment: String)
}

protocol ScrollToElementEditing: AnyObject {
    func scrollToElementEditing(indexPath: IndexPath)
}

/*
protocol ModifyTitleFeatureDelegate {
    func modifyTitleFeature(modify: Bool)
}*/



extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

extension String {
    func noSpaceToLast() -> String {
        if self != "" {
            let index = self.index(self.startIndex, offsetBy: self.count-1)
            if self[index...] == " " {
                let index = self.index(self.endIndex, offsetBy: -1)
                return String(self[..<index])
            }
        }
        return self
    }
    
    func findOccurrencesOf(items: [String]) -> Bool {
        var allOccurrencesFind: Bool = true
        for item in items {
            if self.range(of: item) == nil {
                allOccurrencesFind = false
            }
        }
        return allOccurrencesFind
    }
}
