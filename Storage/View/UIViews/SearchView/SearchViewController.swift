//
//  SearchViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 20/11/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var viewModel: SearchViewModel?
    
    var research: Research?
    
    @IBOutlet weak var textFieldBackView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmButton.isHidden = true
        textFieldBackView.borderFocus()
        searchTextField.becomeFirstResponder()
        guard research != nil else { return }
        confirmButton.isHidden = false
        searchTextField.text = research!.search
        viewModel?.textFieldDidResearching(searchTextField.text!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveSearch()
    }
    
    @IBAction func removeView() {
        searchTextField.text = ""
        viewModel?.removeSearch()
        searchTextField.resignFirstResponder()
        remove()
        viewModel?.newChildSettings()
    }
    
    @IBAction func textFieldChanged() {
        guard searchTextField.text != nil else { return }
        viewModel?.textFieldDidResearching(searchTextField.text!)
        if searchTextField.text != "" {
            confirmButton.isHidden = false
        } else {
            confirmButton.isHidden = true
        }
    }
    
    @IBAction func confirmSearch() {
        saveSearch()
    }
    
    private func saveSearch() {
        guard searchTextField.text != nil else { return }
        guard searchTextField.text != "" else { return }
        searchTextField.resignFirstResponder()
        remove()
        viewModel?.researching(searchTextField.text!)
        viewModel?.newChildSettings()
    }
}
