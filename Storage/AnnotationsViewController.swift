//
//  AnnotationsViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 30/09/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class AnnotationsViewController: UIViewController {

    weak var tableViewDelegate: AnnotationsViewControllerDelegate?
    
    var navBarItem: NavBarItem? = .add
    var tableViewStat: TableViewStat?
    var research: Research?
    var lastAnnotationSelected: Annotation?
    
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var settingsContainer: UIView!
    @IBOutlet weak var addOrDeleteButton: UIBarButtonItem!
    
    private let preferences = Preferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarDesign()
        navigationBack()
        navigationItem.title = "Annotations"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        newAnnotationsSettingsViewController()
        newAnnotationsTableViewController()
    }
    
    // MARK: - IBActions
    
    @IBAction func addOrDeleteAction() {
        guard navBarItem != nil else { return }
        switch navBarItem! {
        case .add:
            newMapViewController()
            break
        case .delete:
            tableViewDelegate?.removeAnnotations()
            break
        }
    }
    
    // MARK: - Childs
    
    func newAnnotationsTableViewController() {
        let annotationsTableViewController: AnnotationsTableViewController = instantiate( "AnnotationsTableViewController", storyboard: "Annotations")
        annotationsTableViewController.delegate = self
        tableViewDelegate = annotationsTableViewController
        annotationsTableViewController.annotationsSort = annotationsSortIndex() ?? .increasing
        annotationsTableViewController.research = research
        addChild(annotationsTableViewController, container: tableViewContainer)
    }
    
    func newAnnotationsSettingsViewController() {
        let annotationsSettingsViewController: AnnotationsSettingsViewController = instantiate("AnnotationsSettingsViewController", storyboard: "AnnotationsSettings")
        annotationsSettingsViewController.delegate = self
        annotationsSettingsViewController.searchCount = research?.count ?? 0
        navBarOption(.add)
        addChild(annotationsSettingsViewController, container: settingsContainer)
    }
    
    func newAnnotationsEditViewController() {
        let annotationsEditViewController: AnnotationsEditViewController = instantiate("AnnotationsEditViewController", storyboard: "AnnotationsEdit")
        annotationsEditViewController.delegate = self
        tableViewDelegate?.tableViewEditing()
        tableViewStat = .editing
        navBarOption(.delete)
        addChild(annotationsEditViewController, container: settingsContainer)
    }
    
    func newAnnotationsSortViewController() {
        let annotationsSortViewController: AnnotationsSortViewController = instantiate("AnnotationsSortViewController", storyboard: "AnnotationsSort")
        annotationsSortViewController.delegate = self
        navBarOption(nil)
        addChild(annotationsSortViewController, container: settingsContainer)
    }
    
    func newAnnotationsSearchViewController() {
        let annotationsSearchViewController: AnnotationsSearchViewController = instantiate("AnnotationsSearchViewController", storyboard: "AnnotationsSearch")
        annotationsSearchViewController.delegate = self
        annotationsSearchViewController.research = research
        tableViewDelegate?.textFieldDidBeginResearching()
        tableViewStat = .searching
        navBarOption(nil)
        addChild(annotationsSearchViewController, container: settingsContainer)
    }
    
    func newMapViewController() {
        let mapViewController: MapViewController = instantiate("MapViewController", storyboard: "Map")
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    func newChildSettings() {
        newAnnotationsSettingsViewController()
        guard tableViewStat == .editing else { return }
        tableViewDelegate?.tableViewEndEditing()
        tableViewStat = nil
    }
    
    // MARK: - Navigation Controller Function
    
    func navBarOption(_ option: NavBarItem?) {
        navBarItem = option
        if option == nil {
            addOrDeleteButton.image = nil
            addOrDeleteButton.isEnabled = false
        } else {
            switch option! {
            case .add:
                addOrDeleteButton.isEnabled = true
                addOrDeleteButton.image = UIImage(named: "Mappin")
                break
            case .delete:
                addOrDeleteButton.isEnabled = true
                addOrDeleteButton.image = UIImage(named: "Basket")
                break
            }
        }
    }
}

// MARK: - AnnotationsTableViewControllerDelegate

protocol AnnotationsTableViewControllerDelegate: AnyObject {
    func newAnnotationDetailsTableViewController(_ annotation: Annotation, _ distance: String)
}

extension AnnotationsViewController: AnnotationsTableViewControllerDelegate {
    
    func newAnnotationDetailsTableViewController(_ annotation: Annotation, _ distance: String) {
        let annotationDetailsTableViewController: AnnotationDetailsTableViewController = instantiate("AnnotationDetailsTableViewController", storyboard: "AnnotationDetails")
        annotationDetailsTableViewController.annotation = annotation
        annotationDetailsTableViewController.distance = distance
        navigationController?.pushViewController(annotationDetailsTableViewController, animated: true)
    }
}


// MARK: - AnnotationsSettingsViewControllerDelegate

protocol AnnotationsSettingsViewControllerDelegate: AnyObject {
    func navigationSettings(_ index: Int)
}

extension AnnotationsViewController: AnnotationsSettingsViewControllerDelegate {
    func navigationSettings(_ index: Int) {
        switch index {
        case 0:
            newAnnotationsEditViewController()
            break
        case 1:
            newAnnotationsSortViewController()
            break
        case 2:
            newAnnotationsSearchViewController()
            break
        default:
            break
        }
    }
}

// MARK: - AnnotationsEditViewControllerDelegate

protocol AnnotationsEditViewControllerDelegate: AnyObject {
    func annotationsTableViewEditing()
    func newChildSettings()
}

extension AnnotationsViewController: AnnotationsEditViewControllerDelegate {
    
    func annotationsTableViewEditing() {
        tableViewDelegate?.tableViewEditing()
    }
}

// MARK: - AnnotationsSortViewControllerDelegate

protocol AnnotationsSortViewControllerDelegate: AnyObject {
    func sortChoice(_ annotationsSort: Sort)
    func annotationsSortIndex() -> Sort?
    func newChildSettings()
}

extension AnnotationsViewController: AnnotationsSortViewControllerDelegate {
    
    func sortChoice(_ annotationsSort: Sort) {
        preferences.annotationSort(annotationsSort.rawValue)
        tableViewDelegate?.annotationsSort(annotationsSort)
    }
    
    func annotationsSortIndex() -> Sort? {
        return Sort(rawValue: preferences.annotationSort())
    }
}

// MARK: - AnnotationsSearchViewControllerDelegate

protocol AnnotationsSearchViewControllerDelegate: AnyObject {
    func textFieldDidResearching(_ text: String)
    func newChildSettings()
    func removeSearch()
    func researching(_ text: String?)
}

extension AnnotationsViewController: AnnotationsSearchViewControllerDelegate {
    func textFieldDidResearching(_ text: String) {
        tableViewDelegate?.textFieldDidResearching(text)
    }
    
    func removeSearch() {
        tableViewDelegate?.textFieldDidEndResearching()
        research = nil
    }
    
    func researching(_ text: String?) {
        guard text != nil || text != "" else { return }
        research = Research.init(search: text!, count: tableViewDelegate?.searchCount() ?? 0)
    }
}
