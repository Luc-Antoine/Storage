//
//  FeaturesViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 13/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class FeaturesViewController: UIViewController {
    
    var controller: FeaturesController?
    
    @IBOutlet weak var settingsContainer: UIView!
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var addOrEditButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        //backButton()
        controller!.instantianteFeaturesTableViewController()
        controller!.instantiateFeaturesSettingsView()
        title = controller!.item!.name
    }
    
    @IBAction func AddOrEditAction() {
        guard controller!.navBarItem != nil else { return }
        switch controller!.navBarItem! {
        case .add:
            controller!.instantiateFeaturesAddView()
        case .delete:
            controller!.delete()
            controller!.featuresTableViewEndEditing()
            break
        }
    }
    
    // MARK: - Navigation
    
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
