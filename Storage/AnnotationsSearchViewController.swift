//
//  AnnotationsSearchViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 30/09/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class AnnotationsSearchViewController: UIViewController {

    weak var delegate: AnnotationsSearchViewControllerDelegate?
    
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
        delegate?.textFieldDidResearching(searchTextField.text!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard searchTextField.text != "" else { return }
        saveSearch()
    }
    
    @IBAction func removeView() {
        searchTextField.text = ""
        delegate?.removeSearch()
        searchTextField.resignFirstResponder()
        remove()
        delegate?.newChildSettings()
    }
    
    @IBAction func textFieldChanged() {
        guard searchTextField.text != nil else { return }
        delegate?.textFieldDidResearching(searchTextField.text!)
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
        searchTextField.resignFirstResponder()
        remove()
        delegate?.researching(searchTextField.text)
        delegate?.newChildSettings()
    }
}
