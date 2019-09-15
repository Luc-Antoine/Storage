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
    weak var editTextFieldDelegate: FeaturesEditTextFieldDelegate?
    
    var controller: FeaturesController?
    
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
        case .delete:
            tableViewDelegate?.delete()
            tableViewDelegate?.tableViewEndEditing()
            break
        }
    }
    
    // MARK: - Navigation
    
    func newFeaturesTableViewController() {
        let featuresTableViewController: FeaturesTableViewController = instantiate("FeaturesTableViewController", container: tableViewContainer, storyboard: "Features")
        featuresTableViewController.delegate = self
        tableViewDelegate = featuresTableViewController
        featuresTableViewController.category = category
        featuresTableViewController.item = item
    }
    
    func newFeaturesSettingsViewController() {
        let featuresSettingsViewController: FeaturesSettingsViewController = instantiate("FeaturesSettingsViewController", container: settingsContainer, storyboard: "FeaturesSettingsView")
        featuresSettingsViewController.delegate = self
        navBarOption(.add)
    }
    
    func newFeaturesAddViewController() {
        let featuresAddViewController: FeaturesAddViewController = instantiate("FeaturesAddViewController", container: settingsContainer, storyboard: "FeaturesAddView")
        featuresAddViewController.delegate = self
        navBarOption(nil)
    }
    
    func newFeaturesEditViewController() {
        let featuresEditViewController: FeaturesEditViewController = instantiate("FeaturesEditViewController", container: settingsContainer, storyboard: "FeaturesEditView")
        featuresEditViewController.delegate = self
        editTextFieldDelegate = featuresEditViewController
        navBarOption(.delete)
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
    
    func instantiateAllFeaturesController(_ controller: AllFeaturesController) -> AllFeaturesViewController {
        let storyboard = UIStoryboard(name: "AllFeatures", bundle: nil)
        let allFeaturesViewController = storyboard.instantiateViewController(withIdentifier: "AllFeaturesViewController") as! AllFeaturesViewController
        allFeaturesViewController.controller = controller
        navigationController?.pushViewController(allFeaturesViewController, animated: true)
        return allFeaturesViewController
    }

}

protocol FeaturesTableViewControllerDelegate: AnyObject {
    func newAllFeaturesViewController(_ category: Category, _ item: Item)
    func navBarItemOption() -> NavBarItem?
    func editTextField(_ text: String)
}

extension FeaturesViewController: FeaturesTableViewControllerDelegate {
    
    func newAllFeaturesViewController(_ category: Category, _ item: Item) {
        let allFeaturesViewController: AllFeaturesViewController = instantiate("AllFeaturesViewController", navigationController: navigationController!, storyboard: "AllFeatures")
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
