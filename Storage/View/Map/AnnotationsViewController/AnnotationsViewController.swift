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
    weak var mapViewDelegate: AnnotationsViewControllerToMapViewDelegate?
    
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
        mapViewDelegate?.memoryManager()
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
        let settingsViewController: SettingsViewController = instantiate("SettingsViewController", storyboard: "SettingsView")
        var settingsViewModel = SettingsViewModel()
        settingsViewModel.delegate = self
        settingsViewController.viewModel = settingsViewModel
        settingsViewController.data = "annotations"
        settingsViewController.searchCount = research?.count ?? 0
        navBarOption(.add)
        addChild(settingsViewController, container: settingsContainer)
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
        let sortViewController: SortViewController = instantiate("SortViewController", storyboard: "SortView")
        var sortViewModel = SortViewModel()
        sortViewModel.delegate = self
        sortViewController.data = "annotations"
        sortViewController.viewModel = sortViewModel
        navBarOption(nil)
        addChild(sortViewController, container: settingsContainer)
    }
    
    func newAnnotationsSearchViewController() {
        let searchViewController: SearchViewController = instantiate("SearchViewController", storyboard: "SearchView")
        var searchViewModel = SearchViewModel()
        searchViewModel.delegate = self
        searchViewController.viewModel = searchViewModel
        
        searchViewController.research = research
        tableViewDelegate?.textFieldDidBeginResearching()
        tableViewStat = .searching
        navBarOption(nil)
        addChild(searchViewController, container: settingsContainer)
    }
    
    func newMapViewController() {
        let mapViewController: MapViewController = instantiate("MapViewController", storyboard: "Map")
        mapViewDelegate = mapViewController
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


// MARK: - SettingsViewDelegate

extension AnnotationsViewController: SettingsViewDelegate {
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

// MARK: - SortViewDelegate

extension AnnotationsViewController: SortViewDelegate {
    func newSort(_ sort: Sort) {
        preferences.annotationSort(sort.rawValue)
        tableViewDelegate?.annotationsSort(sort)
    }
    
    func annotationsSortIndex() -> Sort? {
        return Sort(rawValue: preferences.annotationSort())
    }
}

// MARK: - SearchViewDelegate

extension AnnotationsViewController: SearchViewDelegate {
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
