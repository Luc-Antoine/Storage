//
//  CategoryViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 25/01/2017.
//  Copyright © 2017 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoryViewController2: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    weak var controller: CategoryController?
    
    var category: [Category] = []
    var categorySort: ArrayDisplay.Sort = .increasing
    var modify: Bool = false
    var categoriesSelected: [Category] = []
    var filteredCategory: [Category] = []
    var searchActive: Bool = false
    var viewHeight: CGFloat = 0
    var settingSegmentedIndex: Int = 3
    
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
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var addBar: UITextField!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var editBar: UITextField!
    
    private let db = DataBase()
    private let preferences = Preferences()
    private let styleCSS = StyleCSS()
    private let location = Location()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.addTarget(self, action: #selector(beginResearching(_:)), for: .editingChanged)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 23.0), NSAttributedString.Key.foregroundColor: UIColor.white]
        globalDesign()
        firstTime()
        design()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        endResearching()
        
        db.getCategory(completion: { results in
            self.category = results
            self.sortCategories()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        updateView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewHeight = tableView.frame.size.height
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemList" {
            closeSettingsDisplay()
            let index = tableView.indexPathForSelectedRow
            let destination = segue.destination as! ListItemViewController
            if searchActive {
                destination.categorySelected = filteredCategory[index!.row]
            } else {
                destination.categorySelected = category[index!.row]
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !modify
    }
    
    // MARK: - IBActions
    
    @IBAction func settingsDisplay(_ sender: Any) {
        settingSegmentedIndex = settings.selectedSegmentIndex
        switch settings.selectedSegmentIndex {
        case 0:
            addButton.image = #imageLiteral(resourceName: "Basket")
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
    
    @IBAction func cancelEditCategory() {
        updateCategory(indexPath: nil)
        addButton.image = #imageLiteral(resourceName: "Add")
        sortList.isHidden = false
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.setEditing(false, animated: false)
        tableView.layoutMargins = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0)
        modify = false
        categoriesSelected = []
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
        if category.count > 1 {
            switch sortList.selectedSegmentIndex {
            case 0:
                categorySort = .increasing
                break
            case 1:
                categorySort = .decreasing
                break
            case 2:
                categorySort = .favoritesFirst
                break
            case 3:
                categorySort = .favoritesLast
                break
            default:
                break
            }
        }
        sortCategories()
    }
    
    @IBAction func addAndDeleteCategory(_ sender: Any) {
        if !modify {
            if containerView.isHidden {
                settingsView.isHidden = true
                containerView.isHidden = false
            } else {
                switch settingSegmentedIndex {
                case 0:
                    cancelEditCategory()
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
            // notification car on effacce une partie de la BDD.
            let redAlert = UIAlertController(title: String(format: NSLocalizedString("Alert",   comment: "")), message: String(format: NSLocalizedString("Data lost", comment: "")), preferredStyle: UIAlertController.Style.alert)
            redAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.db.deleteCategory(categories: self.categoriesSelected, completion: { success in
                    if success {
                        self.db.getCategory(completion: { results in
                            self.category = results
                        })
                        DispatchQueue.main.async {
                            self.categoriesSelected.removeAll()
                            self.cancelEditCategory()
                            self.hideEditView()
                            self.sortCategories()
                        }
                    }
                })
            }))
            redAlert.addAction(UIAlertAction(title: String(format: NSLocalizedString("Cancel", comment: "")), style: .cancel, handler: nil))
            present(redAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func confirmAddCategory(_ sender: Any) {
        guard addBar.text != "" else { return }
        let newCategoryName: String = addBar.text!
        db.addCategory(categoryName: addBar.text!)
        addBar.text = ""
        
        db.getCategory(completion: { results in
            self.category = results
            self.sortCategories()
        })
        self.tableView.reloadData()
        let newCategory: [Category] = category.filter{ $0.name == newCategoryName }
        let index = category.firstIndex(of: newCategory.first!)
        tableView.scrollToRow(at: IndexPath(row: index!, section: 0), at: .none, animated: true)
    }
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filteredCategory.count
        }
        return category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellCategory2.identifier, for: indexPath) as! CellCategory2
        let categoryCell: Category
        if searchActive {
            categoryCell = filteredCategory[indexPath.row]
            cell.thisCategory = filteredCategory[indexPath.row]
        } else {
            categoryCell = category[indexPath.row]
            cell.thisCategory = category[indexPath.row]
        }
        cell.configureCell(with: categoryCell, index: indexPath.row)
        if categoryCell.favorites == true {
            cell.colorFavorites()
        } else {
            cell.colorCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            updateCategory(indexPath: indexPath)
            categoriesSelected.append(category[indexPath.row])
            editBar.text = category[indexPath.row].name
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            updateCategory(indexPath: indexPath)
            let index = categoriesSelected.firstIndex(of: category[indexPath.row])!
            categoriesSelected.remove(at: index)
            editBar.text = ""
        }
    }
    
    // MARK: - Search Functions
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchActive = false
        searchBar.text = ""
    }
    
    @objc func beginResearching(_ textField: UITextField) {
        searchActive = true
        if searchBar.text! == "" {
            filteredCategory = category
        } else {
            filteredCategory = category.filter({ (results) -> Bool in
                return results.name!.lowercased().contains(searchBar.text!.lowercased())
            })
        }
        sortCategories()
        tableView.reloadData()
    }
    
    func endResearching() {
        textFieldDidEndEditing(searchBar)
        filteredCategory.removeAll()
        tableView.reloadData()
        deselectTextField(textFields: [searchBar])
    }
    
    // MARK: - Others Functions
    
    private func updateCategory(indexPath: IndexPath?) {
        guard categoriesSelected.count > 0 else { return }
        guard editBar.text != nil else { return }
        guard editBar.text != "" else { return }
        if categoriesSelected.last!.name != editBar.text! {
            db.setCategory(category: categoriesSelected.last!, newName: editBar.text!)
            if indexPath != nil {
                let index = category.firstIndex(of: categoriesSelected.last!)!
                tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            } else {
                tableView.reloadData()
            }
        }
    }
    
    func sortCategories() {
        if category.count > 1 {
            switch categorySort {
            case .increasing:
                category = category.sorted(by: { $0.name!.lowercased() < $1.name!.lowercased() })
                break
            case .decreasing:
                category = category.sorted(by: { $0.name!.lowercased() > $1.name!.lowercased() })
                break
            case .favoritesFirst:
                category = category.sorted(by: { $0.favorites && !$1.favorites })
                break
            case .favoritesLast:
                category = category.sorted(by: { !$0.favorites && $1.favorites })
                break
            }
        }
        self.tableView.reloadData()
    }
    
    @objc func reloadTableView(_ notification: Notification) {
        tableView.reloadData()
    }
    
    // MARK: - Keyboard Functions
    
    @objc func keyboardDidAppear() {
        guard modify else { return }
        guard categoriesSelected.count > 0 else { return }
        let index = category.firstIndex(of: categoriesSelected.last!)!
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
        containerView.isHidden = true
        editView.isHidden = true
        searchView.isHidden = true
        sortView.isHidden = true
        addView.isHidden = true
        styleCSS.borderTextField(textFields: [searchBar, addBar, editBar])
    }
    
    private func updateView() {
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
    
    // MARK: - Open Functions
    
    private func firstTime() {
        controller?.firstTime()
    }
    
    private func globalDesign() {
        styleCSS.tabBarColor()
        styleCSS.navigationBarColor()
    }
}

// MARK: - CellCategory

class CellCategory2: UITableViewCell {
    
    static let identifier = "CellCategory2"
    var thisCategory: Category?
    var favorites: Bool = false
    
    @IBOutlet weak var nameCategory: UILabel!
    @IBOutlet weak var buttonFavorites: UIButton!
    
    private let db = DataBase()
    
    @IBAction func favorites(_ sender: Any) {
        db.setFavorites(category: thisCategory!, favorites: favorites)
        NotificationCenter.default.post(name: .reload, object: nil)
    }
    
    func configureCell(with cell: Category, index: Int) {
        nameCategory.text = cell.name!
        favorites = cell.favorites
    }
    
    func colorCell() {
        buttonFavorites.setImage(#imageLiteral(resourceName: "NewStar"), for: .normal)
    }
    
    func colorFavorites() {
        buttonFavorites.setImage(#imageLiteral(resourceName: "NewStarFavorite"), for: .normal)
    }
}
