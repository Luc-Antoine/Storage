//
//  AnnotationsTableViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 01/10/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class AnnotationsTableViewController: UITableViewController {

    weak var delegate: AnnotationsTableViewControllerDelegate?
    weak var viewModelDelegate: AnnotationsViewModelDelegate?
    
    var lastLocation: LastLocation?
    
    var annotations: [Annotation] = []
    var researchingAnnotations: [Annotation] = []
    var selectedAnnotations: [Annotation] = []
    var modify: Bool = false
    var research: Research?
    var currentLocation: Position?
    var lastIndexPath: IndexPath?
    
    var categories: [Category] = []
    var categoriesSelected: [Int] = []
    
    private let annotationList = AnnotationList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if categoriesSelected.count > 0 {
            loadFilteredAnnotations()
        } else {
            loadAnnotations()
        }
        if research != nil {
            textFieldDidResearching(research!.search)
        } else {
            tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if research != nil {
            return researchingAnnotations.count
        } else {
            return annotations.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AnnotationsTableViewCell.identifier, for: indexPath) as! AnnotationsTableViewCell
        var annotation: Annotation?
        if research != nil {
            annotation = researchingAnnotations[indexPath.row]
        } else {
            annotation = annotations[indexPath.row]
        }
        cell.configureCell(annotation!, viewModelDelegate?.distance(annotation!.distance) ?? "")
        cell.index = indexPath.row
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if modify {
            selectedAnnotations.append(annotations[indexPath.row])
            lastIndexPath = indexPath
        } else {
            let distance: String = viewModelDelegate?.distance(annotations[indexPath.row].distance) ?? ""
            if research != nil {
                delegate?.newAnnotationDetailsTableViewController(researchingAnnotations[indexPath.row], distance)
            } else {
                delegate?.newAnnotationDetailsTableViewController(annotations[indexPath.row], distance)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        lastIndexPath = nil
        guard modify else { return }
        let index = selectedAnnotations.firstIndex(of: annotations[indexPath.row])
        guard index != nil else { return }
        selectedAnnotations.remove(at: index!)
    }
    
    // MARK: - Controller Functions
    
    func scrolling(row: Int) {
        self.tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: row, section: 0), at: .none, animated: true)
    }
    
    // MARK: - Private Functions
    
    private func find() -> [Annotation] {
        let allAnnotations = annotationList.all()
        var filteredAnnotations: [Annotation] = []
        for id in categoriesSelected {
            for annotation in allAnnotations {
                if annotation.categories.contains(id) {
                    filteredAnnotations.append(annotation)
                    continue
                }
            }
        }
        return filteredAnnotations
    }
    
    private func loadAnnotations() {
        annotations = annotationList.all()
        sortAnnotations()
    }
    
    private func loadFilteredAnnotations() {
        annotations = find()
        sortAnnotations()
    }
    
    func sortAnnotations() {
        guard lastLocation?.isAuthorised ?? false else { return }
        for i in 0 ..< annotations.count {
            annotations[i].distance = lastLocation?.distance(of: Position(lat: annotations[i].lat, lng: annotations[i].lng)) ?? 0
        }
        annotations = annotations.sorted(by: { $0.distance < $1.distance })
        tableView.reloadData()
    }

}

protocol AnnotationCellDelegate: AnyObject {
    func selectAnnotation(_ index: Int)
    func reloadAnnotation(_ annotation: Annotation)
}

extension AnnotationsTableViewController: AnnotationCellDelegate {
    func selectAnnotation(_ index: Int) {
        lastIndexPath = IndexPath(row: index, section: 0)
    }
    
    func reloadAnnotation(_ annotation: Annotation) {
        guard lastIndexPath != nil else { return }
        if annotations.indices.contains(lastIndexPath!.row) {
            annotations[lastIndexPath!.row] = annotation
        } else {
            annotations.append(annotation)
        }
        tableView!.reloadRows(at: [lastIndexPath!], with: .automatic)
    }
}

// MARK: - AnnotationsViewControllerDelegate

protocol AnnotationsViewControllerDelegate: AnyObject {
    func sortAnnotations()
    func reloadData()
    func addAnnotation(_ annotation: Annotation?)
    func update(_ title: String, _ subtitle: String, _ comment: String) -> Bool
    func removeAnnotations()
    func textFieldDidBeginResearching()
    func textFieldDidEndResearching()
    func textFieldDidResearching(_ text: String)
    func searchCount() -> Int
    func tableViewEditing()
    func tableViewEndEditing()
}

extension AnnotationsTableViewController: AnnotationsViewControllerDelegate {
    
    func reloadData() {
        sortAnnotations()
        tableView.reloadData()
    }
    
    // MARK: - Annotations Functions
    
    func addAnnotation(_ annotation: Annotation?) {
        guard annotation != nil else { return }
        tableView.reloadData()
    }
    
    func update(_ title: String, _ subtitle: String, _ comment: String) -> Bool {
        guard lastIndexPath != nil else { return false }
        var annotation = annotations[lastIndexPath!.row]
        annotation.title = title
        annotation.subtitle = subtitle
        annotation.comment = comment
        annotations[lastIndexPath!.row] = annotation
        annotationList.update(annotation)
        tableView.reloadRows(at: [lastIndexPath!], with: .none)
        lastIndexPath = nil
        return true
    }
    
    func removeAnnotations() {
        annotationList.remove(selectedAnnotations)
        self.annotations = annotationList.all()
        sortAnnotations()
        tableView.reloadData()
    }
    
    // MARK: - Search Functions
    
    func textFieldDidBeginResearching() {
        research = Research.init(search: "", count: 0)
        researchingAnnotations = annotations
    }
    
    func textFieldDidEndResearching() {
        research = nil
        tableView.reloadData()
    }
    
    func textFieldDidResearching(_ text: String) {
        if text == "" {
            researchingAnnotations = annotations
        } else {
            researchingAnnotations = annotations.filter({ (results) -> Bool in
                return results.title.lowercased().contains(text.lowercased())
            })
        }
        tableView.reloadData()
    }
    
    func searchCount() -> Int {
        return researchingAnnotations.count
    }
    
    func tableViewEditing() {
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(true, animated: true)
        tableView.layoutMargins = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 0)
        modify = true
    }
    
    func tableViewEndEditing() {
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.setEditing(false, animated: false)
        tableView.layoutMargins = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 0)
        modify = false
        lastIndexPath = nil
        tableView.reloadData()
    }
}
