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
    weak var editTextFieldDelegate: FeaturesEditTextFieldDelegate?
    
    var category: Category?
    var item: Item?
    var navBarItem: NavBarItem? = .add
    
    @IBOutlet weak var settingsContainer: UIView!
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var addOrEditButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBack()
        newFeaturesTableViewController()
        newFeaturesSettingsViewController()
        title = item!.name
    }
    
    @IBAction func AddOrEditAction() {
        guard navBarItem != nil else { return }
        switch navBarItem! {
        case .add:
            newFeaturesAddViewController()
            tableViewDelegate?.reloadData()
            break
        case .delete:
            tableViewDelegate?.delete()
            tableViewDelegate?.tableViewEndEditing()
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
        let featuresSettingsViewController: FeaturesSettingsViewController = instantiate("FeaturesSettingsViewController", storyboard: "FeaturesSettingsView")
        featuresSettingsViewController.delegate = self
        navBarOption(.add)
        addChild(featuresSettingsViewController, container: settingsContainer)
    }
    
    func newFeaturesAddViewController() {
        let featuresAddViewController: FeaturesAddViewController = instantiate("FeaturesAddViewController", storyboard: "FeaturesAddView")
        featuresAddViewController.delegate = self
        navBarOption(nil)
        addChild(featuresAddViewController, container: settingsContainer)
    }
    
    func newFeaturesEditViewController() {
        let featuresEditViewController: FeaturesEditViewController = instantiate("FeaturesEditViewController", storyboard: "FeaturesEditView")
        featuresEditViewController.delegate = self
        editTextFieldDelegate = featuresEditViewController
        navBarOption(.delete)
        tableViewDelegate?.reloadData()
        addChild(featuresEditViewController, container: settingsContainer)
    }
    
    func newChildSettings() {
        newFeaturesSettingsViewController()
    }
    
    func navBarOption(_ option: NavBarItem?) {
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
        }
    }
}

protocol FeaturesTableViewControllerDelegate: AnyObject {
    func newAllFeaturesViewController(_ nameFeature: NameFeature, _ feature: Feature?)
    func navBarItemOption() -> NavBarItem?
    func editTextField(_ text: String)
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
        editTextFieldDelegate?.text(text)
    }
}

protocol FeaturesSettingsViewControllerDelegate: AnyObject {
    func newFeaturesEditViewController()
}

extension FeaturesViewController: FeaturesSettingsViewControllerDelegate {
    
}

protocol FeaturesAddViewControllerDelegate: AnyObject {
    func add(_ name: String)
    func newFeaturesSettingsViewController()
}

extension FeaturesViewController: FeaturesAddViewControllerDelegate {
    
    func add(_ name: String) {
        let nameFeature = NameFeature(id: 0, name: name, categoryId: category!.id)
        tableViewDelegate?.add(nameFeature)
    }
}

protocol FeaturesEditViewControllerDelegate: AnyObject {
    func featuresTableViewEditing()
    func featuresTableViewEndEditing()
    func editNameFeature(_ name: String)
    func newFeaturesSettingsViewController()
}

extension FeaturesViewController: FeaturesEditViewControllerDelegate {
    
    func featuresTableViewEditing() {
        tableViewDelegate?.tableViewEditing()
    }
    
    func featuresTableViewEndEditing() {
        tableViewDelegate?.tableViewEndEditing()
    }
    
    func editNameFeature(_ name: String) {
        
    }
}
