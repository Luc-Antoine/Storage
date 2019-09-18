//
//  AllFeaturesTableViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 15/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class AllFeaturesTableViewController: UITableViewController {
    
    weak var delegate: AllFeaturesTableViewControllerDelegate?
    
    var item: Item?
    var features: [Feature] = []
    var selectedFeatures: [Feature] = []
    var feature: Feature?
    var nameFeature: NameFeature?
    var researching: Bool = false
    
    private let allFeatureList = AllFeatureList()

    override func viewDidLoad() {
        super.viewDidLoad()

        features = allFeatureList.all(nameFeature!.id)
        selectedFeatures = features
    }

    // MARK: - TableView Datasource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedFeatures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllFeaturesTableViewCell.identifier, for: indexPath) as! AllFeaturesTableViewCell
        cell.configureCell(selectedFeatures[indexPath.row].name)
        return cell
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        update(features[indexPath.row])
        delegate?.close(features[indexPath.row])
    }
    
    // MARK: - DataBase Functions
    
    func update(_ newFeature: Feature) {
        allFeatureList.increase(newFeature)
        allFeatureList.insert(item!, nameFeature!, newFeature)
        guard feature != nil else { return }
        if feature!.count > 1 {
            allFeatureList.decrease(feature!)
        } else {
            allFeatureList.delete(item!, nameFeature!, feature!)
        }
    }
}

protocol AllFeaturesViewControllerDelegate: AnyObject {
    func researching(_ text: String)
    func researching(_ bool: Bool)
}

extension AllFeaturesTableViewController: AllFeaturesViewControllerDelegate {
    
    func researching(_ text: String) {
        if text != "" {
            selectedFeatures = features.filter({ (results) -> Bool in
                return results.name.lowercased().contains(text.lowercased())
            })
        } else {
            selectedFeatures = features
        }
        tableView.reloadData()
    }
    
    func researching(_ bool: Bool) {
        researching = bool
    }
}
