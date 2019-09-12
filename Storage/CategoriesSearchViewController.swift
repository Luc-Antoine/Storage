//
//  CategoriesSearch.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 02/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class CategoriesSearchViewController: UIViewController {
    
    weak var delegate: CategoriesSearchViewControllerDelegate?
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchTextField.borderDesign()
        searchTextField.becomeFirstResponder()
    }
    
    @IBAction func removeView() {
        searchTextField.resignFirstResponder()
        remove()
        delegate?.removeChildSettings()
    }
    
    @IBAction func textFieldChanged() {
        guard searchTextField.text != nil else { return }
        delegate?.textFieldDidResearching(searchTextField.text!)
    }
}
