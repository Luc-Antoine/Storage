//
//  AllFeatureViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 08/08/2018.
//  Copyright © 2018 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class AllFeaturesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var allFeatures: [String] = []
    var isResearching: Bool = false
    var featureSelected: Int = 0
    var researchingFeature: [String] = []
    var featuresDelegate: FeaturesDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    
    private let styleCSS = StyleCSS()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        searchBar.addTarget(self, action: #selector(beginResearching(_:)), for: .editingChanged)
        design()
    }
    
    // MARK: - IBactions
    
    @IBAction func CancelResearch(_ sender: Any) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        cancelButton.isHidden = true
        researchingFeature.removeAll()
        isResearching = false
        tableView.reloadData()
    }
    
    // MARK: - Table View Data Source
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isResearching {
            return researchingFeature.count
        } else {
            return allFeatures.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllFeaturesCell.identifier, for: indexPath) as! AllFeaturesCell
        if isResearching {
            cell.configureCell(title: researchingFeature[indexPath.row])
        } else {
            cell.configureCell(title: allFeatures[indexPath.row])
        }
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isResearching {
            featuresDelegate?.setFeature(thisFeature: researchingFeature[tableView.indexPathForSelectedRow!.row], thisIndex: featureSelected)
        } else {
            featuresDelegate?.setFeature(thisFeature: allFeatures[tableView.indexPathForSelectedRow!.row], thisIndex: featureSelected)
        }
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Text Field Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchBar.becomeFirstResponder()
        isResearching = true
        cancelButton.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchBar.resignFirstResponder()
        isResearching = false
    }
    
    // MARK: - Research Functions
    
    @objc func beginResearching(_ textField: UITextField) {
        if searchBar.text == "" {
            researchingFeature = allFeatures
        } else {
            researchingFeature = allFeatures.filter({ (results) -> Bool in
                return results.lowercased().contains(self.searchBar.text!.lowercased())
            })
        }
        tableView.reloadData()
    }
    
    // MARK: - Design Functions
    
    private func design() {
        allFeatures = allFeatures.sorted(by: { $0 < $1 })
        styleCSS.borderTextField(textFields: [searchBar])
        cancelButton.isHidden = true
    }
}

class AllFeaturesCell: UITableViewCell {
    static let identifier = "allFeaturesCell"
    
    @IBOutlet weak var feature: UILabel!
    
    func configureCell(title: String) {
        feature.text = title
    }
}
