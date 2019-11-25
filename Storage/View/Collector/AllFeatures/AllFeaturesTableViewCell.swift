//
//  AllFeaturesTableViewCell.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 15/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class AllFeaturesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var featureLabel: UILabel!
    
    func configureCell(_ name: String) {
        featureLabel.text = name
    }

}
