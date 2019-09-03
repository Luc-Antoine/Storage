//
//  FeaturesTableViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 13/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

protocol FeaturesTableViewDelegate: AnyObject {
    func selectNameFeature(_ index: Int)
    func reloadFeature(_ feature: Feature)
}

class FeaturesTableViewController: UITableViewController {
    
    var controller: FeaturesController?
    var lastIndexPath: IndexPath?
    var featureName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller!.nameFeatures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if controller!.navBarItem == .add {
            let cell = tableView.dequeueReusableCell(withIdentifier: FeaturesTableViewCell.identifier, for: indexPath) as! FeaturesTableViewCell
            cell.configureCell(nameFeature: controller!.nameFeatures[indexPath.row], featureName: features(controller!.nameFeatures[indexPath.row].id), featureCount: controller!.selectCount(indexPath.row, feature: features(controller!.nameFeatures[indexPath.row].id)))
            cell.featureTextField.tag = indexPath.row
            cell.featureTextField.delegate = self
            cell.featuresTableViewDelegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NameFeaturesTableViewCell.identifier, for: indexPath) as! NameFeaturesTableViewCell
            cell.configureCell(controller!.nameFeatures[indexPath.row].name)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if controller!.navBarItem == .add {
            return 84
        } else {
            return 44
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lastIndexPath = indexPath
        controller!.featuresEditView?.editTextField.text = controller!.nameFeatures[indexPath.row].name
        controller!.feature = controller!.features.indices.contains(indexPath.row) ? controller!.features[indexPath.row] : nil
        
        if let index = controller!.nameFeaturesSelected.firstIndex(of: controller!.nameFeatures[indexPath.row]) {
            controller!.nameFeaturesSelected.remove(at: index)
        } else {
            controller!.nameFeaturesSelected.append(controller!.nameFeatures[indexPath.row])
        }
    }
    
    // MARK: - Controller Functions
    
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
    
    // MARK: - Private Functions
    
    private func features(_ index: Int) -> String {
        if let feature = controller!.features.first(where: { $0.nameFeatureId == index }) {
            return feature.name
        }
        return ""
    }
    
    private func features(_ index: Int) -> Feature? {
        if let feature = controller!.features.first(where: { $0.nameFeatureId == index }) {
            return feature
        }
        return nil
    }
}

extension FeaturesTableViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        featureName = textField.text ?? ""
        controller!.textFieldDidBeginEditing(textField.tag)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text!.removingEndingSpaces()
        guard featureName != textField.text! else { return }
        controller!.textFieldEndEditing(textField)
    }
}

extension FeaturesTableViewController: FeaturesTableViewDelegate {
    func selectNameFeature(_ index: Int) {
        lastIndexPath = IndexPath(row: index, section: 0)
        let feature: Feature? = controller!.features.first(where: { $0.nameFeatureId == controller!.nameFeatures[index].id })
        controller!.instantiateAllFeaturesController(controller!.nameFeatures[index], feature)
    }
    
    func reloadFeature(_ feature: Feature) {
        guard lastIndexPath != nil else { return }
        if controller!.features.indices.contains(lastIndexPath!.row) {
            controller!.features[lastIndexPath!.row] = feature
        } else {
            controller!.features.append(feature)
        }
        tableView!.reloadRows(at: [lastIndexPath!], with: .automatic)
    }
}
