//
//  ItemsSearchView.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 22/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class ItemsSearchViewController: UIViewController {
    
    weak var delegate: ItemsSearchViewControllerDelegate?
    
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.border()
        searchTextField.paddingLeft()
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
