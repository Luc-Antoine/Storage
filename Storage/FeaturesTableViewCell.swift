//
//  FeaturesTableViewCell.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 13/08/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class FeaturesTableViewCell: UITableViewCell {
    
    weak var featuresTableViewDelegate: FeaturesTableViewDelegate?
    var nameFeature: NameFeature?
    
    @IBOutlet weak var nameFeatureLabel: UILabel!
    @IBOutlet weak var featureTextField: UITextField!
    @IBOutlet weak var featuresButton: UIButton!
    @IBOutlet weak var featuresImage: UIImageView!
    
    @IBAction func instantiateAllFeaturesController() {
        featuresTableViewDelegate?.selectNameFeature(featureTextField.tag)
    }
    
    func configureCell(nameFeature: NameFeature, featureName: String, featureCount: Int) {
        self.nameFeature = nameFeature
        nameFeatureLabel.text = nameFeature.name + " :"
        featureTextField.text = featureName
        featuresButton.isHidden = featureCount == 0
        featuresImage.isHidden = featuresButton.isHidden
        featureTextField.borderActive()
    }
}
