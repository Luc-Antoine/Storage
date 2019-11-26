//
//  FeaturesTableViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 13/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class FeaturesTableViewController: UITableViewController {
    
    weak var delegate: FeaturesTableViewControllerDelegate?
    
    var category: Category?
    var item: Item?
    var oldFeature: Feature?
    var features: [Feature] = []
    var nameFeatures: [NameFeature] = []
    var nameFeaturesSelected: [NameFeature] = []
    var lastIndexPath: IndexPath? {
        didSet {
            guard lastIndexPath != nil else { return }
            guard self.features.indices.contains(lastIndexPath!.row) else { return }
            delegate?.featureSelected(features[lastIndexPath!.row])
        }
    }
    var featureName: String = ""
    
    private let featureList = FeatureList()
    private let preferences = Preferences()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadFeatures()
        loadNameFeatures()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameFeatures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if delegate?.navBarItemOption() == .add {
            let cell = tableView.dequeueReusableCell(withIdentifier: FeaturesTableViewCell.identifier, for: indexPath) as! FeaturesTableViewCell
            cell.configureCell(nameFeature: nameFeatures[indexPath.row], featureName: features(nameFeatures[indexPath.row].id)?.name ?? "", featureCount: selectCount(indexPath.row, feature: features(nameFeatures[indexPath.row].id)))
            cell.featureTextField.tag = indexPath.row
            cell.featureTextField.delegate = self
            cell.featuresTableViewDelegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NameFeaturesTableViewCell.identifier, for: indexPath) as! NameFeaturesTableViewCell
            cell.configureCell(nameFeatures[indexPath.row].name)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if delegate?.navBarItemOption() == .add {
            return 70
        } else {
            return 44
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lastIndexPath = indexPath
        delegate?.editTextField(nameFeatures[indexPath.row].name)
        if let index = nameFeaturesSelected.firstIndex(of: nameFeatures[indexPath.row]) {
            nameFeaturesSelected.remove(at: index)
        } else {
            nameFeaturesSelected.append(nameFeatures[indexPath.row])
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        lastIndexPath = nil
        delegate?.editTextFieldEndEditing()
    }
    
    // MARK: - Private Functions
    
    private func features(_ index: Int) -> Feature? {
        if let feature = features.first(where: { $0.nameFeatureId == index }) {
            return feature
        }
        return nil
    }
    
    private func loadNameFeatures() {
        nameFeatures = featureList.all(category!.id)
    }
    
    private func loadFeatures() {
        features = featureList.all(item!.id)
    }
    
    // MARK: - DataBase Functions
    
    func selectCount(_ index: Int, feature: Feature?) -> Int {
        return featureList.selectCount(nameFeatures[index].id)
    }
    
    func add(_ feature: Feature, nameFeature: NameFeature) {
        let lastFeatureId = preferences.lastFeatureId()
        preferences.lastFeatureId(lastFeatureId)
        featureList.add(feature, nameFeature, item!)
        features.append(feature)
    }
    
    func add(_ nameFeature: NameFeature) {
        featureList.add(nameFeature)
        loadFeatures()
        loadNameFeatures()
        tableView.reloadData()
    }
    
    func update(_ name: String) -> Bool {
        guard lastIndexPath != nil else { return false }
        var nameFeature = nameFeatures[lastIndexPath!.row]
        nameFeature.name = name
        nameFeatures[lastIndexPath!.row] = nameFeature
        featureList.update(nameFeature)
        tableView.reloadRows(at: [lastIndexPath!], with: .none)
        lastIndexPath = nil
        return true
    }
    
    func update(_ feature: Feature, _ index: Int) {
        featureList.update(feature, index, item!, nameFeatures[index])
        oldFeature(index)
    }
    
    func oldFeature(_ index: Int) {
        guard oldFeature != nil else { return }
        featureList.oldFeature(item!, nameFeatures[index], oldFeature!)
    }
}

extension FeaturesTableViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.borderFocus()
        featureName = textField.text ?? ""
        oldFeature = features.first(where: { $0.nameFeatureId == nameFeatures[textField.tag].id })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.borderActive()
        textField.text = textField.text!.removingEndingSpaces()
        guard featureName != textField.text! else { return }
        let nameFeature = nameFeatures[textField.tag]
        let lastId = featureList.lastFeatureId()
        let feature = Feature(id: lastId, name: textField.text!, count: 1, itemId: item!.id, nameFeatureId: nameFeature.id, featureId: lastId)
        update(feature, textField.tag)
        if features.indices.contains(textField.tag) {
            features[textField.tag] = feature
        } else {
            features.append(feature)
        }
        tableView.reloadRows(at: [IndexPath(row: textField.tag, section: 0)], with: .none)
    }
}

protocol FeaturesTableViewDelegate: AnyObject {
    func selectNameFeature(_ index: Int)
    func reloadFeature(_ feature: Feature)
}

extension FeaturesTableViewController: FeaturesTableViewDelegate {
    
    func selectNameFeature(_ index: Int) {
        lastIndexPath = IndexPath(row: index, section: 0)
        let feature: Feature? = features.first(where: { $0.nameFeatureId == nameFeatures[index].id })
        delegate?.newAllFeaturesViewController(nameFeatures[index], feature)
    }
    
    func reloadFeature(_ feature: Feature) {
        guard lastIndexPath != nil else { return }
        if features.indices.contains(lastIndexPath!.row) {
            features[lastIndexPath!.row] = feature
        } else {
            features.append(feature)
        }
        tableView!.reloadRows(at: [lastIndexPath!], with: .automatic)
    }
}

protocol FeaturesViewControllerDelegate: AnyObject {
    func tableViewEditing()
    func tableViewEndEditing()
    func reloadData()
    func separator()
    func delete() -> Bool
    func isEditing() -> Bool
    func update(_ name: String) -> Bool
    func add(_ nameFeature: NameFeature)
}

extension FeaturesTableViewController: FeaturesViewControllerDelegate {
    
    // MARK: - Editing Functions
    
    func tableViewEditing() {
        isEditing = true
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(true, animated: true)
        tableView.layoutMargins = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 0)
    }
    
    func tableViewEndEditing() {
        isEditing = false
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.setEditing(false, animated: false)
        tableView.layoutMargins = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.reloadData()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func separator() {
        if delegate?.navBarItemOption() == .add {
            tableView.separatorStyle = .none
        } else {
            tableView.separatorStyle = .singleLine
            tableView.separatorColor = UIColor.separator
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    func delete() -> Bool {
        guard nameFeaturesSelected.count > 0 else { return false }
        featureList.remove(nameFeaturesSelected)
        nameFeaturesSelected.removeAll()
        loadFeatures()
        loadNameFeatures()
        lastIndexPath = nil
        tableView.reloadData()
        return true
    }
    
    func isEditing() -> Bool {
        return isEditing
    }
}
