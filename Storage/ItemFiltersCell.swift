//
//  ItemFiltersCell.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 19/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class ItemFiltersCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func configureCell(_ feature: Feature) {
        nameLabel.text = feature.name
    }
    
    func select() {
        backView.backgroundColor = UIColor.separator
    }
    
    func unselect() {
        backView.backgroundColor = UIColor.white
    }

}
