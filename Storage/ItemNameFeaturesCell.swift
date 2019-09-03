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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
//        if selected {
//            backView.backgroundColor = UIColor.separator
//        } else {
//            backView.backgroundColor = UIColor.white
//        }
        // Configure the view for the selected state
    }
    
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
