//
//  AllFeaturesViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 15/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class AllFeaturesViewController: UIViewController {
    
    var controller: AllFeaturesController?
    
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var searchTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        let allFeaturesTableViewController = storyboard?.instantiateViewController(withIdentifier: "AllFeaturesTableViewController") as! AllFeaturesTableViewController
        allFeaturesTableViewController.controller = controller
        add(allFeaturesTableViewController)
        title = controller!.nameFeature!.name
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //remove()
    }
    
    // MARK: - IBActions
    
    @IBAction func researching() {
        
    }
    
    // MARK: - Navigate Function
    
    func close() {
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
}
