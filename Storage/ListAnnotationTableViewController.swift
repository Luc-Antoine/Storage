//
//  ListAnnotationTableViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 16/03/2017.
//  Copyright © 2017 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class ListAnnotationTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var allAnnotations: [NSDictionary] = [NSDictionary]()
    var annotation: [Annotation] = []
    var annotationSort: ArrayDisplay.Sort = .increasing
    var modify: Bool = false
    var annotationSelected: [Annotation] = []
    var filteredAnnotation: [Annotation] = []
    var searchActive: Bool = false
    var viewHeight: CGFloat = 0
    var tabbar: UITabBar = UITabBar()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortList: UISegmentedControl!
    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var modifyButton: UIButton!
    @IBOutlet weak var settings: UISegmentedControl!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var backEditView: UIButton!
    @IBOutlet weak var backSearchView: UIButton!
    @IBOutlet weak var backSortView: UIButton!
    @IBOutlet weak var searchBar: UITextField!
    
    private let db = DataBase()
    private let location = Location()
    private let model = ModelController()
    private let styleCSS = StyleCSS()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: .reload, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        searchBar.addTarget(self, action: #selector(beginResearching(_:)), for: .editingChanged)
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 23.0), NSAttributedString.Key.foregroundColor: UIColor.white]
        design()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        db.getAnnotation(completion: { results in
            self.annotation = results
            self.sortAnnotation()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
        self.viewHeight = self.tableView.frame.size.height
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsAnnotation" {
            closeSettingsDisplay()
            let destination = segue.destination as! AnnotationTableViewController //DetailsAnnotationViewController
            let index = tableView.indexPathForSelectedRow
            destination.annotation = annotation
            destination.index = index!.row
            if searchActive {
                destination.thisAnnotation = filteredAnnotation[index!.row]
                destination.title = model.calculateDistance(distance: location.distance(of: Position(lat: filteredAnnotation[index!.row].lat, lng: filteredAnnotation[index!.row].lng)))
            } else {
                destination.thisAnnotation = annotation[index!.row]
                destination.title = model.calculateDistance(distance: location.distance(of: Position(lat: annotation[index!.row].lat, lng: annotation[index!.row].lng)))
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !modify
    }
    
    // MARK: - IBActions
    
    @IBAction func settingsDisplay(_ sender: Any) {
        switch settings.selectedSegmentIndex {
        case 0:
            editView.isHidden = false
            containerView.isHidden = false
            settingsView.isHidden = true
            settings.selectedSegmentIndex = UISegmentedControl.noSegment
            sortList.isHidden = true
            tableView.allowsMultipleSelectionDuringEditing = true
            tableView.setEditing(true, animated: true)
            tableView.layoutMargins = UIEdgeInsets.init(top: 0, left: 40, bottom: 0, right: 0)
            modify = true
            break
        case 1:
            sortView.isHidden = false
            containerView.isHidden = false
            settingsView.isHidden = true
            settings.selectedSegmentIndex = UISegmentedControl.noSegment
            break
        case 2:
            searchView.isHidden = false
            containerView.isHidden = false
            settingsView.isHidden = true
            settings.selectedSegmentIndex = UISegmentedControl.noSegment
            searchBar.becomeFirstResponder()
            break
        default:
            break
        }
    }
    
    @IBAction func cancelEditAnnotation() {
        sortList.isHidden = false
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.setEditing(false, animated: false)
        tableView.layoutMargins = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        modify = false
        editView.isHidden = true
        containerView.isHidden = true
        settingsView.isHidden = false
    }
    
    @IBAction func hideEditView(_ sender: Any) {
        editView.isHidden = true
        containerView.isHidden = true
        settingsView.isHidden = false
    }
    
    @IBAction func hideSearchView(_ sender: Any) {
        searchView.isHidden = true
        containerView.isHidden = true
        settingsView.isHidden = false
        endResearching()
    }
    
    @IBAction func hideSortView(_ sender: Any) {
        sortView.isHidden = true
        containerView.isHidden = true
        settingsView.isHidden = false
    }
    
    @IBAction func sortChoice() {
        switch sortList.selectedSegmentIndex {
        case 0:
            annotationSort = .increasing
            break
        case 1:
            annotationSort = .decreasing
            break
        case 2:
            annotationSort = .favoritesFirst
            break
        case 3:
            annotationSort = .favoritesLast
            break
        default:
            break
        }
        sortAnnotation()
    }
    
    @IBAction func deleteAnnotation(_ sender: Any) {
        if modify {
            // notification car on effacce une partie de la BDD.
            let redAlert = UIAlertController(title: String(format: NSLocalizedString("Alert", comment: "")), message: String(format: NSLocalizedString("Data lost", comment: "")), preferredStyle: UIAlertController.Style.alert)
            redAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.db.deleteAnnotation(annotations: self.annotationSelected, completion: { success in
                    if success {
                        self.db.getAnnotation(completion: { results in
                            self.annotation = results
                        })
                        DispatchQueue.main.async {
                            self.annotationSelected.removeAll()
                            self.cancelEditAnnotation()
                            self.tableView.reloadData()
                        }
                    }
                })
            }))
            redAlert.addAction(UIAlertAction(title: String(format: NSLocalizedString("Cancel", comment: "")), style: .cancel, handler: nil))
            present(redAlert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filteredAnnotation.count
        } else {
            return annotation.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellAnnotation.identifier, for: indexPath) as! CellAnnotation
        let annotationCell: Annotation
        if searchActive {
            annotationCell = filteredAnnotation[indexPath.row]
        } else {
            annotationCell = annotation[indexPath.row]
        }
        cell.thisAnnotation = annotation[indexPath.row]
        cell.favorites = annotationCell.favorites
        cell.configureCell(with: annotationCell)
        cell.location = location.distance(of: Position.init(lat: annotationCell.lat, lng: annotationCell.lng))
        if annotationCell.favorites == true {
            cell.colorFavoris()
        } else {
            cell.colorCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        annotationSelected.append(annotation[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let index = annotationSelected.firstIndex(of: annotation[indexPath.row])!
        annotationSelected.remove(at: index)
    }
    
    // MARK: - Search Functions
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchActive = false
        searchBar.text = ""
    }
    
    @objc func beginResearching(_ textField: UITextField) {
        searchActive = true
        if searchBar.text! == "" {
            filteredAnnotation = annotation
        } else {
            filteredAnnotation = annotation.filter({ (results) -> Bool in
                return results.title!.lowercased().contains(searchBar.text!.lowercased())
            })
        }
        sortAnnotation()
        tableView.reloadData()
    }
    
    func endResearching() {
        textFieldDidEndEditing(searchBar)
        filteredAnnotation.removeAll()
        tableView.reloadData()
        deselectSearchBar()
    }
    
    private func closeSettingsDisplay() {
        editView.isHidden = true
        searchView.isHidden = true
        sortView.isHidden = true
        containerView.isHidden = true
        settingsView.isHidden = false
        deselectSearchBar()
    }
    
    // MARK: - Others Functions
    
    func sortAnnotation() {
        switch annotationSort {
        case .increasing:
            annotation = annotation.sorted(by: { $0.title!.lowercased() < $1.title!.lowercased() })
            break
        case .decreasing:
            annotation = annotation.sorted(by: { $0.title!.lowercased() > $1.title!.lowercased() })
            break
        case .favoritesFirst:
            annotation = annotation.sorted(by: { $0.favorites && !$1.favorites })
            break
        case .favoritesLast:
            annotation = annotation.sorted(by: { !$0.favorites && $1.favorites })
            break
        }
        tableView.reloadData()
    }
    
    @objc func reloadTableView(_ notification: Notification) {
        tableView.reloadData()
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.tableView.frame.size.height == viewHeight {
                self.tableView.frame.size.height -= (keyboardSize.height - (tabBarController?.tabBar.frame.size.height ?? 49))
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.tableView.frame.size.height != viewHeight {
                self.tableView.frame.size.height += (keyboardSize.height - (tabBarController?.tabBar.frame.size.height ?? 49))
            }
        }
    }
    
    private func design() {
        containerView.isHidden = true
        editView.isHidden = true
        searchView.isHidden = true
        sortView.isHidden = true
        styleCSS.radiusUIButton(buttons: [modifyButton])
        styleCSS.borderTextField(textFields: [searchBar])
    }
    
    private func deselectSearchBar() {
        searchBar.resignFirstResponder()
    }
}

// MARK: - CellAnnotation

class CellAnnotation: UITableViewCell {
    static let identifier = "AnnotationCell"
    var thisAnnotation: Annotation?
    var favorites: Bool = false
    var location: Double = 0
    var index: Int = 0
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!
    
    private let db = DataBase()
    private let model = ModelController()
    
    @IBAction func setFavoris(_ sender: UIButton) {
        db.setFavorites(annotation: thisAnnotation!, favorites: !favorites)
        NotificationCenter.default.post(name: .reload, object: nil)
    }
    
    func configureCell(with cell: Annotation) {
        title.text = cell.title!
        subtitle.text = model.calculateDistance(distance: location)
        favorites = cell.favorites
    }
    
    func colorCell() {
        favoritesButton.setImage(#imageLiteral(resourceName: "NewStar"), for: .normal)
    }
    
    func colorFavoris() {
        favoritesButton.setImage(#imageLiteral(resourceName: "NewStarFavorite"), for: .normal)
    }
}
