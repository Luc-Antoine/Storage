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
    weak var filterDelegate: AnnotationCategoriesToAnnotationsViewControllerDelegate?
    
    var navBarItem: NavBarItem? = .add
    var tableViewStat: TableViewStat?
    var research: Research?
    var lastAnnotationSelected: Annotation?
    var lastLocation: LastLocation?
    
    var categories: [Category] = []
    var categoriesSelected: [Int] = []
    var isFiltered: Bool = false
    
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var settingsContainer: UIView!
    @IBOutlet weak var addOrDeleteButton: UIBarButtonItem!
    
    private var annotationsViewModel = AnnotationsViewModel()
    private let categoryList = CategoryList()
    private let preferences = Preferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        annotationsViewModel.lastLocation = lastLocation
        navigationBarDesign()
        navigationBack()
        navigationItem.title = "Annotations"
        categories = categoryList.all()
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
        let annotationsTableViewController: AnnotationsTableViewController = instantiate("AnnotationsTableViewController", storyboard: "Annotations")
        annotationsTableViewController.delegate = self
        annotationsTableViewController.viewModelDelegate = self
        tableViewDelegate = annotationsTableViewController
        annotationsTableViewController.lastLocation = lastLocation
        annotationsTableViewController.research = research
        annotationsTableViewController.categories = categories
        annotationsTableViewController.categoriesSelected = categoriesSelected
        addChild(annotationsTableViewController, container: tableViewContainer)
    }
    
    func newAnnotationCategoriesTableViewController() {
        let annotationCategoriesTableViewController: AnnotationCategoriesTableViewController = instantiate("AnnotationCategoriesTableViewController", storyboard: "AnnotationCategories")
        filterDelegate = annotationCategoriesTableViewController
        annotationCategoriesTableViewController.categories = categories
        annotationCategoriesTableViewController.categoriesSelected = categoriesSelected
        addChild(annotationCategoriesTableViewController, container: tableViewContainer)
    }
    
    func newAnnotationsSettingsViewController() {
        let settingsViewController: SettingsViewController = instantiate("SettingsViewController", storyboard: "SettingsView")
        var settingsViewModel = SettingsViewModel()
        settingsViewModel.delegate = self
        settingsViewController.viewModel = settingsViewModel
        settingsViewController.data = "annotations"
        settingsViewController.categoriesSelectedCount = categoriesSelected.count
        settingsViewController.searchCount = research?.count ?? 0
        navBarOption(.add)
        addChild(settingsViewController, container: settingsContainer)
    }
    
    func newAnnotationsFilterViewController() {
        let annotationsFilterViewController: AnnotationsFilterViewController = instantiate("AnnotationsFilterViewController", storyboard: "AnnotationsFilter")
        annotationsFilterViewController.delegate = self
        navBarOption(nil)
        addChild(annotationsFilterViewController, container: settingsContainer)
        newAnnotationCategoriesTableViewController()
    }
    
    func newAnnotationsEditViewController() {
        let annotationsEditViewController: AnnotationsEditViewController = instantiate("AnnotationsEditViewController", storyboard: "AnnotationsEdit")
        annotationsEditViewController.delegate = self
        tableViewDelegate?.tableViewEditing()
        tableViewStat = .editing
        navBarOption(.delete)
        addChild(annotationsEditViewController, container: settingsContainer)
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
    
    func showAnnotations() {
        filterDelegate?.remove()
        newAnnotationsTableViewController()
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
    func distance(position: Position) -> Double
    func locationIsAuthorised() -> Bool
}

extension AnnotationsViewController: AnnotationsTableViewControllerDelegate {
    func newAnnotationDetailsTableViewController(_ annotation: Annotation, _ distance: String) {
        let annotationDetailsTableViewController: AnnotationDetailsTableViewController = instantiate("AnnotationDetailsTableViewController", storyboard: "AnnotationDetails")
        annotationDetailsTableViewController.annotation = annotation
        annotationDetailsTableViewController.distance = distance
        navigationController?.pushViewController(annotationDetailsTableViewController, animated: true)
    }
    
    func distance(position: Position) -> Double {
        return lastLocation?.distance(of: position) ?? Double.infinity
    }
    
    func locationIsAuthorised() -> Bool {
        return lastLocation?.isAuthorised ?? false
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
            newAnnotationsFilterViewController()
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

// MARK: - AnnotationsFilterViewControllerDelegate

protocol AnnotationsFilterViewControllerDelegate: AnyObject {
    func newAnnotationsTableViewController()
    func newChildSettings()
    func filters()
    func resetFilters()
}

extension AnnotationsViewController: AnnotationsFilterViewControllerDelegate {
    func filters() {
        isFiltered = true
        categoriesSelected = filterDelegate?.categoriesFiltered() ?? []
        showAnnotations()
    }
    
    func resetFilters() {
        isFiltered = false
        categoriesSelected.removeAll()
        showAnnotations()
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

// MARK: - AnnotationsViewModelDelegate

extension AnnotationsViewController: AnnotationsViewModelDelegate {
    func distanceFormatted(lat: Double, lng: Double) -> String {
        annotationsViewModel.distanceFormatted(lat: lat, lng: lng)
    }
}
