//
//  ItemNameFeaturesCell.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 19/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class ItemNameFeaturesCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var nameFeatureLabel: UILabel!
    
    func configureCell(_ nameFeature: NameFeature) {
        nameFeatureLabel.text = nameFeature.name
    }
    
    func select() {
        backView.backgroundColor = UIColor.separator
    }
    
    func unselect() {
        backView.backgroundColor = UIColor.white
    }

}
