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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ nameFeature: String) {
        nameFeatureLabel.text = nameFeature
    }

}
