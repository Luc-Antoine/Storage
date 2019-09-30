//
//  AllFeaturesViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 15/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class AllFeaturesViewController: UIViewController {
    
    weak var featuresTableViewDelegate: FeaturesTableViewDelegate?
    weak var tableViewDelegate: AllFeaturesViewControllerDelegate?
    
    var item: Item?
    var nameFeature: NameFeature?
    var feature: Feature?
    
    @IBOutlet weak var textFieldBackView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var hideKeyboardButtonItem: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        textFieldBackView.borderActive()
        newAllFeaturesTableViewController()
        title = nameFeature!.name
    }
    
    @IBAction func searchTextFieldChanged() {
        tableViewDelegate?.researching(searchTextField.text ?? "")
    }
    
    @IBAction func hideKeyboard() {
        searchTextField.resignFirstResponder()
    }
    
    // MARK: - Navigation
    
    func newAllFeaturesTableViewController() {
        let allFeaturesTableViewController: AllFeaturesTableViewController = instantiate("AllFeaturesTableViewController", storyboard: "AllFeatures")
        tableViewDelegate = allFeaturesTableViewController
        allFeaturesTableViewController.delegate = self
        allFeaturesTableViewController.item = item
        allFeaturesTableViewController.feature = feature
        allFeaturesTableViewController.nameFeature = nameFeature
        addChild(allFeaturesTableViewController, container: tableViewContainer)
    }
}

// MARK: - TextField Delegate

extension AllFeaturesViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldBackView.borderFocus()
        hideKeyboardButtonItem.image = UIImage(named: "Keyboard")
        tableViewDelegate?.researching(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldBackView.borderActive()
        hideKeyboardButtonItem.image = nil
        tableViewDelegate?.researching(false)
    }
}

// MARK: - AllFeaturesTableViewControllerDelegate

protocol AllFeaturesTableViewControllerDelegate: AnyObject {
    func close(_ newFeature: Feature?)
}

extension AllFeaturesViewController: AllFeaturesTableViewControllerDelegate {
    func close(_ newFeature: Feature?) {
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
        guard feature != nil else { return }
        featuresTableViewDelegate?.reloadFeature(newFeature!)
    }
}
