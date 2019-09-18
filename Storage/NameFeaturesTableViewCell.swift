//
//  NameFeaturesTableViewCell.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 14/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class NameFeaturesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameFeatureLabel: UILabel!
    
    func configureCell(_ nameFeature: String) {
        nameFeatureLabel.text = nameFeature
    }
    
//    func select() {
//        backView.backgroundColor = UIColor.separator
//    }
//    
//    func unselect() {
//        backView.backgroundColor = UIColor.white
//    }

}
