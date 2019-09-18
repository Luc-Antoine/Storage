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
    var feature: Feature?
    var features: [Feature] = []
    var nameFeatures: [NameFeature] = []
    var nameFeaturesSelected: [NameFeature] = []
    var lastIndexPath: IndexPath?
    var featureName: String = ""
    
    private let featureList = FeatureList()
    private let preferences = Preferences()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
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
            cell.configureCell(nameFeature: nameFeatures[indexPath.row], featureName: features(nameFeatures[indexPath.row].id), featureCount: selectCount(indexPath.row, feature: features(nameFeatures[indexPath.row].id)))
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
            return 84
        } else {
            return 44
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lastIndexPath = indexPath
        delegate?.editTextField(nameFeatures[indexPath.row].name)
//        controller!.featuresEditView?.editTextField.text = nameFeatures[indexPath.row].name
        feature = features.indices.contains(indexPath.row) ? features[indexPath.row] : nil
        
        if let index = nameFeaturesSelected.firstIndex(of: nameFeatures[indexPath.row]) {
            nameFeaturesSelected.remove(at: index)
            // TableView reload cell
        } else {
            nameFeaturesSelected.append(nameFeatures[indexPath.row])
        }
    }
    
    // MARK: - Edit naùe feature
    
    func edit(_ name: String) {
//        featuresEditView?.editTextField.text = name
//        let index = featuresTableViewController?.lastIndexPath?.row
//        guard index != nil else { return }
//        update(index!, name: name)
//        featuresTableViewController!.tableView.reloadRows(at: [IndexPath(row: index!, section: 0)], with: .automatic)
//        featuresEditView?.editTextField.text = ""
    }
    
    // MARK: - Private Functions
    
    private func features(_ index: Int) -> String {
        if let feature = features.first(where: { $0.nameFeatureId == index }) {
            return feature.name
        }
        return ""
    }
    
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
        //sort()
    }
    
    func add(_ nameFeature: NameFeature) {
        featureList.add(nameFeature)
        loadFeatures()
        loadNameFeatures()
        tableView.reloadData()
    }
    
    func update(_ index: Int, name: String) {
        var nameFeature = nameFeatures[index]
        nameFeature.name = name
        nameFeatures[index] = nameFeature
        featureList.update(nameFeature)
    }
    
    func update(_ feature: Feature, _ index: Int) {
        featureList.update(feature, index, item!, nameFeatures[index])
        
//        let featureAlreadySaved: Feature? = dataBase.check(feature)
//        if featureAlreadySaved != nil {
//            dataBase.increase(featureAlreadySaved!)
//            dataBase.insert(item!, nameFeature: nameFeatures[index], feature: featureAlreadySaved!)
//        } else {
//            dataBase.insert(feature)
//            dataBase.insert(item!, nameFeature: nameFeatures[index], feature: feature)
//        }
        
        oldFeature(index)
    }
    
    func oldFeature(_ index: Int) {
        guard oldFeature != nil else { return }
        featureList.oldFeature(item!, nameFeatures[index], oldFeature!)
        
//        dataBase.delete(item!, nameFeature: nameFeatures[index], feature: oldFeature!)
//        if oldFeature!.count > 1 {
//            dataBase.decrease(oldFeature!)
//        } else {
//            dataBase.delete(oldFeature!)
//        }
    }
}

extension FeaturesTableViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        featureName = textField.text ?? ""
        oldFeature = features.first(where: { $0.nameFeatureId == nameFeatures[textField.tag].id })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text!.removingEndingSpaces()
        guard featureName != textField.text! else { return }
        let nameFeature = nameFeatures[textField.tag]
        let lastId = featureList.lastFeatureId()
        let feature = Feature(id: lastId, name: textField.text!, count: 1, itemId: item!.id, nameFeatureId: nameFeature.id, featureId: lastId)
        update(feature, textField.tag)
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
        //controller!.instantiateAllFeaturesController(nameFeatures[index], feature)
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
    func delete()
    func update(_ index: Int, name: String)
    func add(_ nameFeature: NameFeature)
}

extension FeaturesTableViewController: FeaturesViewControllerDelegate {
    
    // MARK: - Editing Functions
    
    func tableViewEditing() {
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(true, animated: true)
        tableView.layoutMargins = UIEdgeInsets.init(top: 0, left: 40, bottom: 0, right: 0)
    }
    
    func tableViewEndEditing() {
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.setEditing(false, animated: false)
        tableView.layoutMargins = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0)
        tableView.reloadData()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func delete() {
        print(nameFeaturesSelected)
        nameFeaturesSelected.removeAll()
    }
    
}
