//
//  ListFeatureViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 22/09/2017.
//  Copyright © 2017 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

protocol LastTextFieldEditing {
    func getLastTextFieldEditing(text: String, index: Int)
}

class ListFeatureViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, FeaturesDelegate, CellDelegate, LastTextFieldEditing {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var textFiedlDelegate: UITextField? = nil
    var titleFeature: [String] = []
    var feature: [String] = []
    var allTitlesAndFeatures: [String:[String]] = [:]
    var featureSelected: [Int] = []
    var titleSelected: Int = 0
    var categorySelected: Category?
    var itemSelected: Item?
    var items: [Item] = []
    var cellSelected: Int = 0
    var viewHeight: CGFloat = 0
    var newFeature: Bool = false
    var modify: Bool = false
    var cellTextFiledEditing: Bool = false
    var settingSegmentedIndex: Int = 3
    
    var listFeatures: [String] = []
    var listFeatureSorted: [String] = []
    
    var indexCellSelected: Int?
    
    @IBOutlet weak var viewTableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var backEditView: UIButton!
    @IBOutlet weak var backAddView: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var addBar: UITextField!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var editBar: UITextField!
    
    private let db = DataBase()
    private let styleCSS = StyleCSS()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTableView.dataSource = self
        viewTableView.delegate = self
        textFiedlDelegate?.delegate = self
        design()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleFeature = categorySelected!.titleFeature!.components(separatedBy: ",")
        feature = itemSelected!.features!.components(separatedBy: ",")
        if titleFeature[0].count == 0 {
            titleFeature = []
            feature = []
        }
        reloadTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewHeight = viewTableView.frame.size.height
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AllFeatures" {
            let destination = segue.destination as! AllFeaturesViewController
            destination.allFeatures = allTitlesAndFeatures[titleFeature[indexCellSelected!]]!
            destination.title = titleFeature[indexCellSelected!]
            destination.featureSelected = indexCellSelected!
            destination.featuresDelegate = self
            indexCellSelected = nil
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if indexCellSelected == nil {
            return false
        } else {
            return true
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func editFeature() {
        if cellTextFiledEditing {
            viewTableView.resignFirstResponder()
            viewTableView.reloadData()
            cellTextFiledEditing = false
            editButton.setTitle(NSLocalizedString("Edit", comment: ""), for: .normal)
        } else {
            addButton.image = #imageLiteral(resourceName: "Basket")
            editView.isHidden = false
            containerView.isHidden = false
            settingsView.isHidden = true
            viewTableView.allowsMultipleSelectionDuringEditing = true
            viewTableView.setEditing(true, animated: true)
            viewTableView.layoutMargins = UIEdgeInsets.init(top: 0, left: 40, bottom: 0, right: 0)
            settingSegmentedIndex = 0
            modify = true
        }
    }
    
    @IBAction func cancelEditFeature() {
        updateFeature(indexPath: nil)
        addButton.image = #imageLiteral(resourceName: "Add")
        viewTableView.allowsMultipleSelectionDuringEditing = false
        viewTableView.setEditing(false, animated: false)
        viewTableView.layoutMargins = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        viewTableView.reloadData()
        modify = false
        cellTextFiledEditing = false
        editButton.setTitle(NSLocalizedString("Edit", comment: ""), for: .normal)
        featureSelected = []
    }
    
    @IBAction func hideEditView() {
        editView.isHidden = true
        containerView.isHidden = true
        settingsView.isHidden = false
        editBar.resignFirstResponder()
        editBar.text = ""
    }
    
    @IBAction func hideAddView() {
        if cellTextFiledEditing {
            cellTextFiledEditing = false
            editButton.setTitle(NSLocalizedString("Edit", comment: ""), for: .normal)
        }
        addBar.text = ""
        addView.isHidden = true
        containerView.isHidden = true
        settingsView.isHidden = false
        deselectTextField(textFields: [addBar])
    }
    
    @IBAction func addAndDeleteFeature(_ sender: Any) {
        if !modify {
            if containerView.isHidden {
                settingsView.isHidden = true
                containerView.isHidden = false
            }
            cancelEditFeature()
            editView.isHidden = true
            addView.isHidden = false
            addBar.becomeFirstResponder()
        } else {
            if modify {
                // notification car on effacce une partie de la BDD.
                let redAlert = UIAlertController(title: String(format: NSLocalizedString("Alert", comment: "")), message: String(format: NSLocalizedString("Data lost", comment: "")), preferredStyle: UIAlertController.Style.alert)
                redAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    self.featureSelected = self.featureSelected.sorted(by: { $0 > $1 })
                    for item in self.items {
                        var itemFeatures = item.features?.components(separatedBy: ",")
                        for i in 0..<self.featureSelected.count {
                            itemFeatures!.remove(at: self.featureSelected[i])
                        }
                        let features = itemFeatures?.joined(separator: ",")
                        self.db.setFeature(item: item, feature: features!)
                    }
                    for i in 0..<self.featureSelected.count {
                        self.titleFeature.remove(at: self.featureSelected[i])
                    }
                    let titleFeatures = self.titleFeature.joined(separator: ",")
                    self.db.setTitleFeature(category: self.categorySelected!, titleFeature: titleFeatures)
                    self.featureSelected.removeAll()
                    self.cancelEditFeature()
                    self.hideEditView()
                    self.viewTableView.reloadData()
                }))
                redAlert.addAction(UIAlertAction(title: String(format: NSLocalizedString("Cancel", comment: "")), style: .cancel, handler: nil))
                present(redAlert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func confirmAddFeature(_ sender: Any) {
        guard addBar.text != "" else { return }
        var textFeature = addBar.text!
        textFeature = textFeature.noSpaceToLast()
        guard titleFeature.firstIndex(of: textFeature) == nil else {
            doubleFeature()
            return
        }
        if titleFeature.last != "" {
            newFeature = true
            cellSelected = titleFeature.count
            titleFeature.append(textFeature)
            feature.append("")
            addBar.text = ""
            saveFeature()
            reloadTableView()
        }
    }
    
    // MARK: - Table View Data Source
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleFeature.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewTableView.dequeueReusableCell(withIdentifier: CellFeature.identifier, for: indexPath) as! CellFeature
        cell.configureCell(titleFeatureText: titleFeature[indexPath.row], featureText: feature[indexPath.row], index: indexPath.row)
        cell.feature.tag = indexPath.row
        cell.feature.delegate = self
        cell.textFieldEditing = self
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !modify {
            tableView.cellForRow(at: indexPath)!.contentView.backgroundColor = UIColor.white
        }
        if tableView.isEditing {
            updateFeature(indexPath: indexPath)
            featureSelected.append(indexPath.row)
            editBar.text = titleFeature[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            updateFeature(indexPath: indexPath)
            featureSelected.remove(at: featureSelected.firstIndex(of: indexPath.row)!)
            editBar.text = ""
        }
    }
    
    // MARK: - Text Field Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField != addBar && textField != editBar {
            cellTextFiledEditing = true
            editButton.setTitle("Ok", for: .normal)
        }
        textField.becomeFirstResponder()
        cellSelected = textField.tag
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text! = textField.text!.noSpaceToLast()
        textField.resignFirstResponder()
        feature[cellSelected] = textField.text!
        db.setFeature(item: itemSelected!, feature: feature.joined(separator: ","))
        if textField == editBar {
            editBar.text = ""
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == titleFeature.count - 1 && newFeature {
            newFeature = false
            self.viewTableView.scrollToRow(at: IndexPath(row: cellSelected, section: 0), at: .bottom, animated: true)
        }
    }
    
    // MARK: - Cell Delegate
    
    func getRow(index: Int, title: String, textFieldText: String) {
        indexCellSelected = index
        addFeature(title: title, textFieldText: textFieldText)
        cellTextFiledEditing = false
        editButton.setTitle(NSLocalizedString("Edit", comment: ""), for: .normal)
        performSegue(withIdentifier: "AllFeatures", sender: nil)
    }
    
    
    
    // MARK: - Keyboard Functions
    
    @objc func keyboardDidAppear() {
        guard modify else { return }
        guard featureSelected.count > 0 else { return }
        viewTableView.scrollToRow(at: viewTableView.indexPathForSelectedRow!, at: .top, animated: true)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            viewTableView.contentInset = UIEdgeInsets.zero
        } else {
            viewTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - 49, right: 0)
        }
        
        viewTableView.scrollIndicatorInsets = viewTableView.contentInset
    }
    
    // MARK: - Others Functions
    
    private func updateFeature(indexPath: IndexPath?) {
        guard featureSelected.count > 0 else { return }
        guard editBar.text != nil else { return }
        guard editBar.text != "" else { return }
        if titleFeature[featureSelected.last!] != editBar.text! {
            let oldTitleFeature = titleFeature[featureSelected.last!]
            titleFeature[featureSelected.last!] = editBar.text!.noSpaceToLast()
            allTitlesAndFeatures[titleFeature[featureSelected.last!]] = allTitlesAndFeatures[oldTitleFeature]
            allTitlesAndFeatures[oldTitleFeature]?.removeAll()
            db.setTitleFeature(category: categorySelected!, titleFeature: titleFeature.joined(separator: ","))
            
            if indexPath != nil {
                viewTableView.reloadRows(at: [IndexPath(row: featureSelected.last!, section: 0)], with: .none)
            } else {
                viewTableView.reloadData()
            }
        }
    }
    
    private func addFeature(title: String, textFieldText: String) {
        guard textFieldText != "" else { return }
        guard allTitlesAndFeatures[title]?.firstIndex(of: textFieldText.noSpaceToLast()) == nil else { return }
        allTitlesAndFeatures[title]?.append(textFieldText.noSpaceToLast())
    }
    
    func setFeature(thisFeature: String, thisIndex: Int) {
        let text = thisFeature.noSpaceToLast()
        feature[thisIndex] = text
        db.setFeature(item: itemSelected!, feature: feature.joined(separator: ","))
        viewTableView.reloadData()
    }
    
    func reloadTableView() {
        while feature.count < titleFeature.count {
            feature.append("")
        }
        viewTableView.reloadData()
        if newFeature {
            viewTableView.scrollToRow(at: IndexPath(row: cellSelected, section: 0), at: .bottom, animated: true)
        }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardDidAppear), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    private func design() {
        title = itemSelected!.name!
        containerView.isHidden = true
        editView.isHidden = true
        addView.isHidden = true
        //styleCSS.buttonLikeSegmentedControl(buttons: [editButton])
        styleCSS.borderTextField(textFields: [addBar, editBar])
        viewTableView.keyboardDismissMode = .onDrag
        viewTableView.keyboardDismissMode = .interactive
    }
    
    private func deselectTextField(textFields: [UITextField]) {
        for textField in textFields {
            textField.resignFirstResponder()
        }
    }
    
    private func saveFeature() {
        db.setTitleFeature(category: categorySelected!, titleFeature: titleFeature.joined(separator: ","))
        db.setFeature(item: itemSelected!, feature: feature.joined(separator: ","))
    }

    private func doubleFeature() {
        let redAlert = UIAlertController(title: String(format: NSLocalizedString("Alert", comment: "")), message: String(format: NSLocalizedString("Double feature", comment: "")), preferredStyle: UIAlertController.Style.alert)
        redAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        present(redAlert, animated: true, completion: nil)
    }
    
    func getLastTextFieldEditing(text: String, index: Int) {
        feature[index] = text
        db.setFeature(item: itemSelected!, feature: feature.joined(separator: ","))
    }
}

// MARK: - CellFeature

class CellFeature: UITableViewCell {
    
    static let identifier: String = "FeatureCell"
    var delegate: CellDelegate?
    var textFieldEditing: LastTextFieldEditing?
    
    @IBOutlet weak var titleFeature: UILabel!
    @IBOutlet weak var feature: UITextField!
    @IBOutlet weak var setFeatureButton: UIButton!
    
    private let styleCSS = StyleCSS()
    
    @IBAction func showFeatureList() {
        delegate?.getRow(index: setFeatureButton.tag, title: titleFeature.text!, textFieldText: feature.text!)
    }
    
    func configureCell(titleFeatureText: String, featureText: String, index: Int) {
        titleFeature.text = titleFeatureText
        feature.text = featureText
        styleCSS.borderTextField(textFields: [feature])
        setFeatureButton.tag = index
    }
    
    @IBAction func saveTextField() {
        textFieldEditing?.getLastTextFieldEditing(text: feature.text!, index: feature.tag)
    }
}
