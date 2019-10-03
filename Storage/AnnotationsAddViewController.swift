//
//  AnnotationsAddViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 30/09/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class AnnotationsAddViewController: UIViewController {

    weak var delegate: AnnotationsAddViewControllerDelegate?
    
    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var textFieldBackView: UIView!
    @IBOutlet weak var nameAnnotationTextField: UITextField!
    @IBOutlet weak var confirmeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameAnnotationTextField.becomeFirstResponder()
        textFieldBackView.borderFocus()
    }
    
    @IBAction func addAnnotation() {
//        delegate?.addAnnotation(nameAnnotationTextField.text?.removingEndingSpaces())
//        nameAnnotationTextField.text = ""
    }
    
    @IBAction func close() {
        nameAnnotationTextField.resignFirstResponder()
        remove()
        delegate?.newChildSettings()
    }

}
