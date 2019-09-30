//
//  ItemsFilterView.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 02/06/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class ItemsFilterViewController: UIViewController {
    
    weak var delegate: ItemsFilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        validateButtonTitle()
        cancelButton.border()
        validateButton.border()
    }
    
    @IBOutlet weak var filterTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var validateButton: UIButton!
    
    @IBAction func confirm() {
        delegate?.filters()
        validateButtonTitle()
        guard delegate?.tableViewKindItem() == .filteredItems else { return }
        remove()
        delegate?.newChildSettings()
    }
    
    @IBAction func removeView() {
        remove()
        delegate?.newChildSettings()
        delegate?.cancelFilter()
    }
    
    private func validateButtonTitle() {
        if delegate?.tableViewKindItem() == .filtersEditing {
            validateButton.setTitle("Nouveau", for: .normal)
        } else {
            validateButton.setTitle("Valider", for: .normal)
        }
    }
}
