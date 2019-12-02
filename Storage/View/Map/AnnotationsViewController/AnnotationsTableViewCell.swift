//
//  AnnotationsTableViewCell.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 30/09/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class AnnotationsTableViewCell: UITableViewCell {

    weak var delegate: AnnotationCellDelegate?
    var index: Int?
    var favorite: Bool = false
    
    @IBOutlet weak var titleAnnotation: UILabel!
    @IBOutlet weak var distanceAnnotation: UILabel!
    @IBOutlet weak var subtitleAnnotation: UILabel!
    @IBOutlet weak var buttonFavorites: UIButton!
    
    @IBAction func favorites(_ sender: Any) {
        update(!favorite)
        delegate?.updateFavorite(index!)
    }
    
    func configureCell(_ annotation: Annotation, _ distance: String) {
        titleAnnotation.text = annotation.title
        subtitleAnnotation.text = annotation.subtitle
        distanceAnnotation.text = distance
        update(annotation.favorite)
    }
    
    private func update(_ favorite: Bool) {
        if favorite {
            buttonFavorites.setImage(UIImage(named: "NewStarFavorite"), for: .normal)
            self.favorite = true
        } else {
            buttonFavorites.setImage(UIImage(named: "NewStar"), for: .normal)
            self.favorite = false
        }
    }
}
