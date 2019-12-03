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
    
    func configureCell(_ annotation: Annotation, _ distance: String) {
        titleAnnotation.text = annotation.title
        subtitleAnnotation.text = annotation.subtitle
        distanceAnnotation.text = distance
    }
}
