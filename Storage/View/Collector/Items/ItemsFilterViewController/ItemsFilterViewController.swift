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
        newView.borderFocus()
        newView.clipsToBounds = true
        buttonsView.borderFocus()
        buttonsView.clipsToBounds = true
    }
    
    @IBOutlet weak var newView: UIView!
    @IBOutlet weak var buttonsView: UIView!
    
    @IBAction func confirm() {
        guard delegate?.tableViewKindItem() != nil else { return }
        delegate?.filters()
        validateButtonTitle()
        guard delegate?.tableViewKindItem() == .filteredItems else { return }
        remove()
        delegate?.newChildSettings()
    }
    
    @IBAction func removeView() {
        delegate?.cancelFilter()
        remove()
        delegate?.newChildSettings()
    }
    
    @IBAction func cancelFilter() {
        delegate?.resetFilters()
        remove()
        delegate?.newChildSettings()
    }
    
    private func validateButtonTitle() {
        if delegate?.tableViewKindItem() == .filtersEditing {
            newView.isHidden = false
            buttonsView.isHidden = true
        } else {
            newView.isHidden = true
            buttonsView.isHidden = false
        }
    }
}
