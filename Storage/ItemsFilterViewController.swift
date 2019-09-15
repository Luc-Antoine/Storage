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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cancelButton.border()
        validateButton.border()
    }
    
    @IBOutlet weak var filterTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var validateButton: UIButton!
    
    @IBAction func confirm() {
        delegate?.filters()
        guard delegate?.tableViewKindItem() == .filteredItems else { return }
        remove()
        delegate?.removeChildSettings()
    }
    
    @IBAction func removeView() {
        remove()
        delegate?.removeChildSettings()
        delegate?.cancelFilter()
    }
}
