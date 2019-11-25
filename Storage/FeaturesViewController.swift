//
//  FeaturesViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 13/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class FeaturesViewController: UIViewController {
    
    weak var tableViewDelegate: FeaturesViewControllerDelegate?
    weak var featuresTableViewDelegate: FeaturesTableViewDelegate?
    weak var editToViewControllersDelegate: EditToViewControllersDelegate?
    
    var category: Category?
    var item: Item?
    var navBarItem: NavBarItem? = .add
    var lastFeatureSelected: Feature?
    
    @IBOutlet weak var settingsContainer: UIView!
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var addOrEditButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        title(item!.name)
        navigationBack()
        newFeaturesTableViewController()
        newFeaturesSettingsViewController()
    }
    
    @IBAction func AddOrEditAction() {
        guard navBarItem != nil else { return }
        switch navBarItem! {
        case .add:
            newFeaturesAddViewController()
            tableViewDelegate?.reloadData()
            break
        case .delete:
            if tableViewDelegate?.delete() ?? false {
                tableViewDelegate?.tableViewEndEditing()
                editToViewControllersDelegate?.text("")
            }
            break
        }
    }
    
    // MARK: - Navigation
    
    func newFeaturesTableViewController() {
        let featuresTableViewController: FeaturesTableViewController = instantiate("FeaturesTableViewController", storyboard: "Features")
        featuresTableViewController.delegate = self
        tableViewDelegate = featuresTableViewController
        featuresTableViewDelegate = featuresTableViewController
        featuresTableViewController.category = category
        featuresTableViewController.item = item
        addChild(featuresTableViewController, container: tableViewContainer)
    }
    
    func newFeaturesSettingsViewController() {
        let featuresSettingsViewController: FeaturesSettingsViewController = instantiate("FeaturesSettingsViewController", storyboard: "FeaturesSettings")
        featuresSettingsViewController.delegate = self
        navBarOption(.add)
        tableViewDelegate?.reloadData()
        addChild(featuresSettingsViewController, container: settingsContainer)
    }
    
    func newFeaturesAddViewController() {
        let addViewController: AddViewController = instantiate("AddViewController", storyboard: "AddView")
        var addViewModel = AddViewModel()
        addViewModel.delegate = self
        addViewController.viewModel = addViewModel
        navBarOption(nil)
        addChild(addViewController, container: settingsContainer)
    }
    
    func newFeaturesEditViewController() {
        let editViewController: EditViewController = instantiate("EditViewController", storyboard: "EditView")
        var editViewModel = EditViewModel()
        editViewModel.delegate = self
        editViewController.viewModel = editViewModel
        editToViewControllersDelegate = editViewController
        navBarOption(.delete)
        tableViewDelegate?.reloadData()
        addChild(editViewController, container: settingsContainer)
    }
    
    func newChildSettings() {
        newFeaturesSettingsViewController()
    }
    
    func navBarOption(_ option: NavBarItem?) {
        navBarItem = option
        if option == nil {
            addOrEditButton.image = nil
            addOrEditButton.isEnabled = false
        } else {
            switch option! {
            case .add:
                addOrEditButton.isEnabled = true
                addOrEditButton.image = UIImage(named: "Add")
                break
            case .delete:
                addOrEditButton.isEnabled = true
                addOrEditButton.image = UIImage(named: "Basket")
                break
            }
            tableViewDelegate?.separator()
        }
    }
}

// MARK: - FeaturesTableViewControllerDelegate

protocol FeaturesTableViewControllerDelegate: AnyObject {
    func newAllFeaturesViewController(_ nameFeature: NameFeature, _ feature: Feature?)
    func navBarItemOption() -> NavBarItem?
    func editTextField(_ text: String)
    func editTextFieldEndEditing()
    func featureSelected(_ feature: Feature?)
}

extension FeaturesViewController: FeaturesTableViewControllerDelegate {
    func newAllFeaturesViewController(_ nameFeature: NameFeature, _ feature: Feature?) {
        let allFeaturesViewController: AllFeaturesViewController = instantiate("AllFeaturesViewController", storyboard: "AllFeatures")
        allFeaturesViewController.item = item
        allFeaturesViewController.feature = feature
        allFeaturesViewController.nameFeature = nameFeature
        allFeaturesViewController.featuresTableViewDelegate = featuresTableViewDelegate
        navigationController?.pushViewController(allFeaturesViewController, animated: true)
    }
    
    func navBarItemOption() -> NavBarItem? {
        return navBarItem
    }
    
    func editTextField(_ text: String) {
        editToViewControllersDelegate?.text(text)
    }
    
    func editTextFieldEndEditing() {
        editToViewControllersDelegate?.editTextFieldEndEditing()
    }
    
    func featureSelected(_ feature: Feature?) {
        editToViewControllersDelegate?.textFieldBackViewBorder(feature != nil)
        lastFeatureSelected = feature
    }
}

// MARK: - FeaturesSettingsViewControllerDelegate

protocol FeaturesSettingsViewControllerDelegate: AnyObject {
    func newFeaturesEditViewController()
}

extension FeaturesViewController: FeaturesSettingsViewControllerDelegate {
    
}

// MARK: - AddViewDelegate

extension FeaturesViewController: AddViewDelegate {
    func add(_ name: String) {
        let nameFeature = NameFeature(id: 0, name: name, categoryId: category!.id)
        tableViewDelegate?.add(nameFeature)
    }
}

// MARK: - EditViewDelegate

extension FeaturesViewController: EditViewDelegate {
    func tableViewEditing() {
        tableViewDelegate?.tableViewEditing()
    }
    
    func editNameObject(_ name: String) -> Bool {
        return tableViewDelegate?.update(name) ?? false
    }
    
    func objectSelected() -> Bool {
        return lastFeatureSelected != nil
    }
    
    func featuresTableViewEndEditing() {
        tableViewDelegate?.tableViewEndEditing()
    }
}
