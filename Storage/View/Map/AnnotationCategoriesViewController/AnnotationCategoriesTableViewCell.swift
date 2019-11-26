//
//  AnnotationCategoriesTableViewCell.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 26/11/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import UIKit

class AnnotationCategoriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func configureCell(_ category: Category) {
        nameLabel.text = category.name
    }
    
    func select() {
        backView.backgroundColor = UIColor.separator
    }
    
    func unselect() {
        backView.backgroundColor = UIColor.white
    }
}
