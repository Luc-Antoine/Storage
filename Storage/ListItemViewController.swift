//
//  ListItemViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 25/01/2017.
//  Copyright © 2017 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class ListItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    enum DataAsked {
        case items, filtereditems, researchingitems, titlefeatures, features, filtersediting
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [Item] = []
    var listItem: [String] = []
    var titleFeatures: [String] = []
    var allFeatures: [String:[String]] = [:]
    var features: [String] = []
    var categorySelected: Category?
    var titleFeatureSelected: String = ""
    var itemSort: ArrayDisplay.Sort = .increasing
    var modified: Bool = false
    var itemsSelected: [Item] = []
    var filteredItem: [Item] = []
    var researchingItem: [Item] = []
    var searchActive: Bool = false
    var viewHeight: CGFloat = 0
    var settingSegmentedIndex: Int = 3
    var featuresIndex: Int = 0
    var filters: [String] = []
    var filtersSelected: [String] = []
    
    var dataAsked: DataAsked = .items
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var sortList: UISegmentedControl!
    @IBOutlet weak var settings: UISegmentedControl!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var backEditView: UIButton!
    @IBOutlet weak var backSearchView: UIButton!
    @IBOutlet weak var backSortView: UIButton!
    @IBOutlet weak var backAddView: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var endFilterButton: UIButton!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var addBar: UITextField!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var editBar: UITextField!
    
    private let db = DataBase()
    private let styleCSS = StyleCSS()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        searchBar.addTarget(self, action: #selector(beginResearching(_:)), for: .editingChanged)
        design()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        db.getItem(predicateFormat: "category_id == \(categorySelected!.id)", completion: { results in
            self.items = results
            
            DispatchQueue.main.async {
                self.sortItem()
            }
        })
        titleFeatures = categorySelected!.titleFeature!.components(separatedBy: ",")
        updateView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewHeight = tableView.frame.size.height
        DispatchQueue.global(qos: .userInteractive).async {
            self.getAllFeatures()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Feature" {
            closeSettingsDisplay()
            let index = tableView.indexPathForSelectedRow?.row
            let destination = segue.destination as! ListFeatureViewController
            destination.categorySelected = categorySelected!
            destination.items = items
            destination.itemSelected = items[tableView.indexPathForSelectedRow!.row]
            destination.allTitlesAndFeatures = allFeatures
            switch dataAsked {
            case .items:
                destination.itemSelected = items[index!]
                break
            case .filtereditems:
                destination.itemSelected = filteredItem[index!]
                break
            case .researchingitems:
                destination.itemSelected = researchingItem[index!]
                break
            case .titlefeatures:
                break
            case .features:
                break
            case .filtersediting:
                break
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !modified
    }
    
    // MARK: - IBActions
    
    @IBAction func settingsDisplay(_ sender: Any) {
        switch settings.selectedSegmentIndex {
        case 0:
            if dataAsked == .filtereditems {
                dataAsked = .filtersediting
                tableView.reloadData()
            }
            addButton.image = #imageLiteral(resourceName: "Basket")
            editView.isHidden = false
            containerView.isHidden = false
            settingsView.isHidden = true
            settings.selectedSegmentIndex = UISegmentedControl.noSegment
            sortList.isHidden = true
            tableView.allowsMultipleSelectionDuringEditing = true
            tableView.setEditing(true, animated: true)
            tableView.layoutMargins = UIEdgeInsets.init(top: 0, left: 40, bottom: 0, right: 0)
            modified = true
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
            endFilterButton.isHidden = true
            settings.selectedSegmentIndex = UISegmentedControl.noSegment
            searchBar.becomeFirstResponder()
            break
        case 3:
            searchView.isHidden = false
            containerView.isHidden = false
            settingsView.isHidden = true
            if filters.count > 0 {
                endFilterButton.isHidden = false
            }
            settings.selectedSegmentIndex = UISegmentedControl.noSegment
            dataAsked = .titlefeatures
            tableView.reloadData()
            break
        default:
            break
        }
    }
    
    @IBAction func cancelEditItem() {
        updateItem(indexPath: nil)
        addButton.image = #imageLiteral(resourceName: "Add")
        sortList.isHidden = false
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.setEditing(false, animated: false)
        tableView.layoutMargins = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0)
        modified = false
        if dataAsked == .filtersediting {
            filtersSelected.removeAll()
            dataAsked = .filtereditems
            tableView.reloadData()
        } else {
            itemsSelected.removeAll()
        }
    }
    
    @IBAction func hideEditView() {
        editView.isHidden = true
        containerView.isHidden = true
        settingsView.isHidden = false
        editBar.resignFirstResponder()
        editBar.text = ""
    }
    
    @IBAction func hideSearchView() {
        searchView.isHidden = true
        containerView.isHidden = true
        settingsView.isHidden = false
        endResearching()
    }
    
    @IBAction func hideSortView() {
        sortView.isHidden = true
        containerView.isHidden = true
        settingsView.isHidden = false
    }
    
    @IBAction func hideAddView() {
        addBar.text = ""
        addView.isHidden = true
        containerView.isHidden = true
        settingsView.isHidden = false
        deselectTextField(textFields: [addBar])
    }
    
    @IBAction func sortChoice() {
        switch sortList.selectedSegmentIndex {
        case 0:
            itemSort = .increasing
                break
        case 1:
            itemSort = .decreasing
                break
        case 2:
            itemSort = .favoritesFirst
                break
        case 3:
            itemSort = .favoritesLast
                break
        default:
            break
        }
        sortItem()
    }
    
    @IBAction func addAndDeleteItem(_ sender: Any) {
        if !modified {
            if containerView.isHidden {
                settingsView.isHidden = true
                containerView.isHidden = false
            } else {
                switch settingSegmentedIndex {
                case 0:
                    cancelEditItem()
                    editView.isHidden = true
                    break
                case 1:
                    sortView.isHidden = true
                    break
                case 2:
                    searchView.isHidden = true
                    searchBar.text = ""
                    break
                default:
                    break
                }
            }
            addView.isHidden = false
            addBar.becomeFirstResponder()
        } else {
            if dataAsked == .filtersediting {
                filtersSelected = filtersSelected.sorted(by: { $0 > $1 })
                for filter in filtersSelected {
                    let index = filters.firstIndex(of: filter)!
                    filters.remove(at: index)
                }
                if filters.count > 0 {
                    dataAsked = .filtereditems
                } else {
                    dataAsked = .items
                }
                filtersSelected.removeAll()
                getFilteredItem()
                cancelEditItem()
                hideEditView()
                sortItem()
                updateView()
                tableView.reloadData()
            } else {
                if modified {
                    // notification car on effacce une partie de la BDD.
                    let redAlert = UIAlertController(title: String(format: NSLocalizedString("Alert", comment: "")), message: String(format: NSLocalizedString("Data lost", comment: "")), preferredStyle: UIAlertController.Style.alert)
                    redAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        self.db.deleteItem(items: self.itemsSelected, completion: { success in
                            if success {
                                self.db.getItem(predicateFormat: "category_id == \(self.categorySelected!.id)", completion: { results in
                                    self.items = results
                                })
                                DispatchQueue.main.async {
                                    self.itemsSelected.removeAll()
                                    self.sortItem()
                                    self.cancelEditItem()
                                    self.hideEditView()
                                }
                            }
                        })
                    }))
                    redAlert.addAction(UIAlertAction(title: String(format: NSLocalizedString("Cancel", comment: "")), style: .cancel, handler: nil))
                    present(redAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func confirmAddItem(_ sender: Any) {
        guard addBar.text != "" else { return }
        let newItemName: String = addBar.text!
        db.addItem(category: categorySelected!, itemName: addBar.text!)
        addBar.text = ""
        
        db.getItem(predicateFormat: "category_id == \(categorySelected!.id)", completion: { results in
            self.items = results
            self.sortItem()
        })
        tableView.reloadData()
        let newItem: [Item] = items.filter{ $0.name == newItemName }
        let index = items.firstIndex(of: newItem.first!)
        tableView.scrollToRow(at: IndexPath(row: index!, section: 0), at: .none, animated: true)
    }
    
    @IBAction func endFilter() {
        filters.removeAll()
        settings.setTitle(NSLocalizedString("Filter", comment: ""), forSegmentAt: 3)
        filteredItem.removeAll()
        researchingItem.removeAll()
        dataAsked = .items
        hideSearchView()
        endFilterButton.isHidden = true
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch dataAsked {
        case .items:
            return items.count
        case .filtereditems:
            return filteredItem.count
        case .researchingitems:
            return researchingItem.count
        case .titlefeatures:
            return titleFeatures.count
        case .features:
            return allFeatures[titleFeatureSelected]!.count
        case .filtersediting:
            return filters.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch dataAsked {
        case .items:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellItem.identifier, for: indexPath) as! CellItem
            let itemCell: Item = items[indexPath.row]
            cell.thisItem = itemCell
            cell.configureCell(with: itemCell, index: indexPath.row)
            if itemCell.favorites == true {
                cell.colorFavorites()
            } else {
                cell.colorCell()
            }
            return cell
        case .filtereditems:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellItem.identifier, for: indexPath) as! CellItem
            let itemCell: Item = filteredItem[indexPath.row]
            cell.thisItem = itemCell
            cell.configureCell(with: itemCell, index: indexPath.row)
            if itemCell.favorites == true {
                cell.colorFavorites()
            } else {
                cell.colorCell()
            }
            return cell
        case .researchingitems:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellItem.identifier, for: indexPath) as! CellItem
            let itemCell: Item = researchingItem[indexPath.row]
            cell.thisItem = itemCell
            cell.configureCell(with: itemCell, index: indexPath.row)
            if itemCell.favorites == true {
                cell.colorFavorites()
            } else {
                cell.colorCell()
            }
            return cell
        case .titlefeatures:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellItemTitleFeatures.identifier, for: indexPath) as! CellItemTitleFeatures
            cell.configureCell(with: titleFeatures[indexPath.row], index: indexPath.row)
            return cell
        case .features:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellItemFeatures.identifier, for: indexPath) as! CellItemFeatures
            cell.configureCell(with: allFeatures[titleFeatureSelected]![indexPath.row], index: indexPath.row)
            return cell
        case .filtersediting:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellFilters.identifier, for: indexPath) as! CellFilters
            cell.configureCell(with: filters[indexPath.row], index: indexPath.row)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch dataAsked {
        case .items:
            if tableView.isEditing {
                updateItem(indexPath: indexPath)
                itemsSelected.append(items[indexPath.row])
                editBar.text = items[indexPath.row].name
            }
            break
        case .filtereditems:
            if tableView.isEditing {
                itemsSelected.append(filteredItem[indexPath.row])
            }
            break
        case .researchingitems:
            break
        case .titlefeatures:
            titleFeatureSelected = titleFeatures[indexPath.row]
            featuresIndex = indexPath.row
            dataAsked = .features
            tableView.reloadData()
            break
        case .features:
            filters.append(allFeatures[titleFeatureSelected]![indexPath.row])
            getFilteredItem()
            dataAsked = .filtereditems
            updateView()
            hideSearchView()
            tableView.reloadData()
            break
        case .filtersediting:
            filtersSelected.append(filters[indexPath.row])
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if dataAsked == .items && tableView.isEditing {
            updateItem(indexPath: indexPath)
            let index = itemsSelected.firstIndex(of: items[indexPath.row])!
            itemsSelected.remove(at: index)
            editBar.text = ""
        }
        if dataAsked == .filtersediting {
            let index = filtersSelected.firstIndex(of: filters[indexPath.row])!
            filtersSelected.remove(at: index)
        }
    }
    
    // MARK: - Search Functions
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchActive = false
        searchBar.text = ""
    }
    
    @objc func beginResearching(_ textField: UITextField) {
        searchActive = true
        var listItem: [Item] = []
        dataAsked = .researchingitems
        if filteredItem.count == 0 {
            listItem = items
        } else {
            listItem = filteredItem
        }
        if searchBar.text! == "" {
            researchingItem = listItem
        } else {
            researchingItem = listItem.filter({ (results) -> Bool in
                return results.name!.lowercased().contains(self.searchBar.text!.lowercased())
            })
        }
        sortItem()
        tableView.reloadData()
    }
    
    func endResearching() {
        if filteredItem.count == 0 {
            dataAsked = .items
        } else {
            dataAsked = .filtereditems
        }
        textFieldDidEndEditing(searchBar)
        researchingItem.removeAll()
        tableView.reloadData()
        deselectTextField(textFields: [searchBar])
    }
    
    // MARK: - Filter Functions
    
    private func getAllFeatures() {
        var allFeatureSet: [String:Set<String>] = [:]
        for titleFeature in titleFeatures {
            allFeatures[titleFeature] = []
            allFeatureSet[titleFeature] = []
        }
        for i in 0..<items.count {
            let itemfeatures: [String] = items[i].features!.components(separatedBy: ",")
            for j in 0..<itemfeatures.count {
                if itemfeatures[j] != "" {
                    allFeatureSet[titleFeatures[j]]?.insert(itemfeatures[j]) // ERROR !!!!!
                }
            }
        }
        for titleFeature in titleFeatures {
            allFeatures[titleFeature] = Array(allFeatureSet[titleFeature]!)
        }
    }
    
    private func getFilteredItem() {
        filteredItem = items.filter({ (results) -> Bool in
            return results.features!.findOccurrencesOf(items: filters)
        })
    }
    
    // MARK: - Others Functions
    
    func updateItem(indexPath: IndexPath?) {
        guard itemsSelected.count > 0 else { return }
        guard editBar.text != nil else { return }
        guard editBar.text != "" else { return }
        if itemsSelected.last!.name != editBar.text! {
            db.setItem(item: itemsSelected.last!, newName: editBar.text!)
            if indexPath != nil {
                let index = items.firstIndex(of: itemsSelected.last!)!
                tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            } else {
                tableView.reloadData()
            }
        }
    }
    
    func sortItem() {
        if filteredItem.count > 0 {
            switch itemSort {
            case .increasing:
                filteredItem = filteredItem.sorted(by: { $0.name!.lowercased() < $1.name!.lowercased() })
                break
            case .decreasing:
                filteredItem = filteredItem.sorted(by: { $0.name!.lowercased() > $1.name!.lowercased() })
                break
            case .favoritesFirst:
                filteredItem = filteredItem.sorted(by: { $0.favorites && !$1.favorites })
                break
            case .favoritesLast:
                filteredItem = filteredItem.sorted(by: { !$0.favorites && $1.favorites })
                break
            }
        } else {
            switch itemSort {
            case .increasing:
                items = items.sorted(by: { $0.name!.lowercased() < $1.name!.lowercased() })
                break
            case .decreasing:
                items = items.sorted(by: { $0.name!.lowercased() > $1.name!.lowercased() })
                break
            case .favoritesFirst:
                items = items.sorted(by: { $0.favorites && !$1.favorites })
                break
            case .favoritesLast:
                items = items.sorted(by: { !$0.favorites && $1.favorites })
                break
            }
        }
        self.tableView.reloadData()
    }
    
    @objc func reloadTableView(_ notification: Notification) {
        tableView.reloadData()
    }
    
    @objc func keyboardDidAppear() {
        guard modified else { return }
        guard itemsSelected.count > 0 else { return }
        let index = items.firstIndex(of: itemsSelected.last!)!
        tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: true)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentInset = UIEdgeInsets.zero
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - 49, right: 0)
        }
        
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    private func design() {
        title = categorySelected!.name!
        containerView.isHidden = true
        editView.isHidden = true
        searchView.isHidden = true
        sortView.isHidden = true
        addView.isHidden = true
        styleCSS.borderTextField(textFields: [searchBar, addBar, editBar])
    }
    
    private func updateView() {
        if filters.count > 0 {
            settings.setTitle(NSLocalizedString("Filter", comment: "") + "(\(filters.count))", forSegmentAt: 3)
        } else {
            settings.setTitle(NSLocalizedString("Filter", comment: ""), forSegmentAt: 3)
        }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(reloadTableView), name: .reload, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardDidAppear), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    private func closeSettingsDisplay() {
        editView.isHidden = true
        searchView.isHidden = true
        sortView.isHidden = true
        addView.isHidden = true
        containerView.isHidden = true
        settingsView.isHidden = false
        deselectTextField(textFields: [searchBar, addBar, editBar])
    }
    
    private func deselectTextField(textFields: [UITextField]) {
        for textField in textFields {
            textField.resignFirstResponder()
        }
    }
}

// MARK: - CellItem

class CellItem: UITableViewCell {
    static let identifier = "ItemCell"
    var thisItem: Item?
    var favorites: Bool = false
    
    @IBOutlet weak var nameItem: UILabel!
    @IBOutlet weak var buttonFavorites: UIButton!
    
    private let db = DataBase()
    
    @IBAction func favorites(_ sender: Any) {
        db.setFavorites(item: thisItem!, favorites: !favorites)
        NotificationCenter.default.post(name: .reload, object: nil)
    }
    
    func configureCell(with cell: Item, index: Int) {
        nameItem.text = cell.name!
        favorites = cell.favorites
    }
    
    func colorCell() {
        buttonFavorites.setImage(#imageLiteral(resourceName: "NewStar"), for: .normal)
    }
    
    func colorFavorites() {
        buttonFavorites.setImage(#imageLiteral(resourceName: "NewStarFavorite"), for: .normal)
    }
}

class CellItemTitleFeatures: UITableViewCell {
    static let identifier = "ItemTitleFeaturesCell"
    
    @IBOutlet weak var titleFeature: UILabel!
    
    func configureCell(with titleFeatureName: String, index: Int) {
        titleFeature.text = titleFeatureName
    }
}

class CellItemFeatures: UITableViewCell {
    static let identifier: String = "ItemFeaturesCell"
    
    @IBOutlet weak var feature: UILabel!
    
    func configureCell(with featureName: String, index: Int) {
        feature.text = featureName
    }
}

class CellFilters: UITableViewCell {
    static let identifier = "FiltersCell"
    
    @IBOutlet weak var filter: UILabel!
    
    func configureCell(with filterName: String, index: Int) {
        filter.text = filterName
    }
}
