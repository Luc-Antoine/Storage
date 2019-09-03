//
//  FeaturesController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 13/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class FeaturesController: UIController {
    
    weak var featuresViewController: FeaturesViewController?
    weak var featuresTableViewController: FeaturesTableViewController?
    
    weak var featuresEditView: FeaturesEditView?
    
    var navBarItem: NavBarItem? = .add
    var features: [Feature] = []
    var feature: Feature?
    var oldFeature: Feature?
    var nameFeatures: [NameFeature] = []
    var nameFeaturesSelected: [NameFeature] = []
    var category: Category?
    var item: Item?
    
    private let dataBase = DataBase()
    private let preferences = Preferences()
    
    // MARK: - Instantiate Functions
    
    func instantiateFeaturesViewController(_ navigationController: UINavigationController) {
        select()
        featuresViewController = instantiate("FeaturesViewController", storyboard: "Features", bundle: nil)
        push(navigationController, viewController: featuresViewController!)
        featuresViewController!.controller = self
    }
    
    func instantianteFeaturesTableViewController() {
        featuresTableViewController = instantiate("FeaturesTableViewController", storyboard: "Features", bundle: nil)
        child(featuresViewController!, child: featuresTableViewController!, container: featuresViewController!.tableViewContainer)
        featuresTableViewController!.controller = self
    }
    
    func removeSettingsContainer() {
        featuresViewController?.settingsContainer.subviews.first?.removeFromSuperview()
    }
    
    func instantiateAllFeaturesController(_ nameFeature: NameFeature, _ feature: Feature?) {
        let allFeaturesController = AllFeaturesController()
        allFeaturesController.item = item!
        allFeaturesController.nameFeature = nameFeature
        allFeaturesController.feature = feature
        allFeaturesController.featuresTableViewDelegate = featuresTableViewController
        allFeaturesController.select()
        allFeaturesController.allFeaturesViewController = featuresViewController?.instantiateAllFeaturesController(allFeaturesController)
    }
    
    func instantiateFeaturesSettingsView() {
        let featuresSettingsView: FeaturesSettingsView = instantiate("FeaturesSettingsView", owner: nil, options: nil)
        child(featuresSettingsView, container: featuresViewController!.settingsContainer)
        featuresSettingsView.controller = self
        featuresSettingsView.viewDidAppear()
        navBarItem(.add)
    }
    
    func instantiateFeaturesAddView() {
        let featuresAddView: FeaturesAddView = instantiate("FeaturesAddView", owner: nil, options: nil)
        child(featuresAddView, container: featuresViewController!.settingsContainer)
        featuresAddView.controller = self
        featuresAddView.viewDidAppear()
        navBarItem(.add)
    }
    
    func instantiateFeaturesEditView() {
        featuresEditView = instantiate("FeaturesEditView", owner: nil, options: nil)
        child(featuresEditView!, container: featuresViewController!.settingsContainer)
        featuresEditView!.controller = self
        featuresEditView!.viewDidAppear()
        navBarItem(.delete)
    }
    
    // MARK: - Edit Function
    
    func featuresTableViewEditing() {
        featuresTableViewController!.tableViewEditing()
    }
    
    func featuresTableViewEndEditing() {
        featuresTableViewController!.tableViewEndEditing()
    }
    
    func textFieldDidBeginEditing(_ index: Int) {
        oldFeature = features.first(where: { $0.nameFeatureId == nameFeatures[index].id })
    }
    
    func textFieldEndEditing(_ textField: UITextField) {
        let nameFeature = nameFeatures[textField.tag]
        let lastId = dataBase.lastFeatureId()
        let feature = Feature(id: lastId, name: textField.text!, count: 1, itemId: item!.id, nameFeatureId: nameFeature.id, featureId: lastId)
        update(feature, textField.tag)
    }
    
    func edit(_ name: String) {
        featuresEditView?.editTextField.text = name
        let index = featuresTableViewController?.lastIndexPath?.row
        guard index != nil else { return }
        update(index!, name: name)
        featuresTableViewController!.tableView.reloadRows(at: [IndexPath(row: index!, section: 0)], with: .automatic)
        featuresEditView?.editTextField.text = ""
    }
    
    // MARK: - Objects Function
    
    func navBarItem(_ option: NavBarItem?) {
        navBarItem = option
        featuresViewController?.navBarOption(option)
        featuresTableViewController?.tableView.reloadData()
    }
    
    func sort() {
        nameFeatures = nameFeatures.sorted(by: {
            $0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending
        })
        featuresTableViewController?.tableView.reloadData()
    }
    
    // MARK: - DataBase Functions
    
    func select() {
        nameFeatures = dataBase.select(category!.id)
        features = dataBase.select(item!.id)
        sort()
    }
    
    func selectCount(_ index: Int, feature: Feature?) -> Int {
        return dataBase.selectCount(nameFeatures[index].id)
    }
    
    func add(_ feature: Feature, nameFeature: NameFeature) {
        let lastFeatureId = preferences.lastFeatureId()
        preferences.lastFeatureId(lastFeatureId)
        dataBase.insert(feature)
        dataBase.insert(nameFeature, item: item!)
        features.append(feature)
        sort()
    }
    
    func add(_ nameFeature: NameFeature) {
        dataBase.insert(nameFeature)
        select()
    }
    
    func update(_ index: Int, name: String) {
        var nameFeature = nameFeatures[index]
        nameFeature.name = name
        nameFeatures[index] = nameFeature
        dataBase.update(nameFeature)
    }
    
    func update(_ feature: Feature, _ index: Int) {
        let featureAlreadySaved: Feature? = dataBase.check(feature)
        if featureAlreadySaved != nil {
            dataBase.increase(featureAlreadySaved!)
            dataBase.insert(item!, nameFeature: nameFeatures[index], feature: featureAlreadySaved!)
        } else {
            dataBase.insert(feature)
            dataBase.insert(item!, nameFeature: nameFeatures[index], feature: feature)
        }
        //featuresTableViewController?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        oldFeature(index)
    }
    
    func oldFeature(_ index: Int) {
        guard oldFeature != nil else { return }
        dataBase.delete(item!, nameFeature: nameFeatures[index], feature: oldFeature!)
        if oldFeature!.count > 1 {
            dataBase.decrease(oldFeature!)
        } else {
            dataBase.delete(oldFeature!)
        }
    }
    
    func delete() {
        print(nameFeaturesSelected)
        nameFeaturesSelected.removeAll()
    }
}
